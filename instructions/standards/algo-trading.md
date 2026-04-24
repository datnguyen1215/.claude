# Algo Trading Standards

## Purpose

Standards for developing consistent, production-ready algorithmic trading strategies with parity between backtest and live systems.

## Data Window Rules

### Rolling Window Requirement
- **Never** use full history in backtests
- **Always** use capped rolling window matching live system constraints
- **Window size** is strategy-dependent; define explicitly per strategy
- **Enforce** identical data access patterns in backtest and live

### Window Size Definition
- Each strategy must declare `MAX_CANDLES` constant
- Backtest must simulate live conditions by only accessing last `MAX_CANDLES`
- Live system fetches/maintains exactly `MAX_CANDLES`

## Indicator & Calculation Rules

### No Full-History Dependencies
- **Never** use indicators requiring full history (e.g., cumulative from start)
- **Never** use calculations that derive from full history
- **All** indicators must be computable with rolling window only
- **Reject** any indicator that changes output when given more history

### Rolling Window Indicators Only
- **Allowed**: SMA, EMA, RSI, ATR, Bollinger Bands (fixed lookback)
- **Forbidden**: Cumulative volume from start, all-time high/low, indicators seeded from bar 0
- **Test**: If indicator output changes when prepending older data, it's invalid

### Indicator Validation
- Indicator must produce identical output whether given 100 bars or 10,000 bars (assuming same recent window)
- If `f(data[-N:]) != f(data)[-1]`, the indicator violates rolling window principle

## Timeframe Alignment Rules

### Timestamp Convention
- **Candle timestamp** = open time (standard convention)
- **Close time** must be calculated: `open_time + timeframe_duration`
- **Be aware**: A candle with timestamp 09:00 on 1h timeframe closes at 10:00

### Multi-Timeframe Alignment
- **Always** use close time for alignment, never open time
- **Higher timeframe bar** is complete when `current_time >= htf_close_time`
- **Alignment formula**: `htf_close_time = htf_open_time + htf_duration`
- **Never** use incomplete bars for signals

### Alignment Algorithm
```
htf_bar_valid_at_ltf_bar = ltf_close_time >= htf_close_time
```

### Incomplete Bar Handling
- **Ignore** incomplete bars entirely
- **Wait** for bar close before processing
- **Never** generate signals from partial data

## Performance Optimization Rules

### Optimization Priority
1. **GPU first** - Try CuPy/CUDA implementation
2. **If no GPU benefit** - Use Numba vectorization
3. **Profile before deciding** - Measure actual performance

### Vectorization Requirements
- **All indicator calculations** must be vectorized
- **No Python loops** over price data
- **Batch operations** over individual bar processing
- **Trade simulation** must use vectorized cumulative operations

### GPU Usage Criteria
- Use GPU when: large data, parallelizable ops, matrix operations
- Skip GPU when: small data (<10k rows), overhead exceeds gain

### Vectorized Backtest Simulation

Trade simulation appears sequential but is fully vectorizable using cumulative operations.

#### Step 1: Pre-compute Trade Outcomes (Parallel)
```python
# All at once - no loops
entry_prices = ...  # vectorized entry detection
exit_prices = ...   # vectorized exit detection
stop_distances = entry_prices - stop_prices

# R-multiples: profit/loss in risk units
r_multiples = (exit_prices - entry_prices) / stop_distances
```

#### Step 2: Equity Curve via Cumulative Product (Parallel)
```python
risk_pct = 0.01  # 1% risk per trade

# Each trade multiplies account by (1 + risk% * R)
trade_multipliers = 1 + risk_pct * r_multiples

# cumprod uses parallel prefix scan - O(log n) not O(n)
equity_curve = initial_balance * cp.cumprod(trade_multipliers)
```

#### Step 3: Metrics via Parallel Scan
```python
peak_equity = cp.maximum.accumulate(equity_curve)
drawdown = (peak_equity - equity_curve) / peak_equity
max_drawdown = cp.max(drawdown)
```

#### Why This Works
| Operation | Naive View | GPU Reality |
|-----------|------------|-------------|
| Trade labeling | Parallel | Direct parallel |
| Account balance | Sequential | `cumprod()` - parallel scan |
| Peak equity | Sequential | `maximum.accumulate()` - parallel scan |
| Drawdown | Sequential | Vectorized division |

**Key insight**: CuPy/CUDA implements cumulative operations using parallel prefix scan algorithms with O(log n) depth.

#### When Sequential is Unavoidable
Only use CPU loops when position sizing depends on:
- Recent trade history (e.g., reduce size after N losses)
- Dynamic volatility scaling within the backtest
- Complex money management that can't be expressed as multiplicative factors

## Execution Assumptions

- **Fills**: Assume complete fill (no partial fills)
- **Entry**: Always execute on bar open
- **No slippage modeling** unless explicitly required

## Backtest Defaults

- **Initial balance**: $10,000
- **Risk per trade**: 1% of account
- **Position sizing**: Derive from risk % and stop loss distance

## Strategy Reporting

### Required Metrics
- **Trade count** - Total number of trades
- **Max drawdown %** - Percentage drop from peak equity
- **Drawdown formula**: `(peak_equity - current_equity) / peak_equity * 100`

## Optimization Rules

### Data Splitting (Mandatory)
- **Training set** - Parameter optimization
- **Validation set** - Hyperparameter tuning, early stopping
- **Testing set** - Final unbiased evaluation (touch once)
- **Never** optimize on full dataset
- **Never** report test set results during development

### Overfitting Prevention
- Optimize on training only
- Validate on unseen validation data
- Test set is for final report only

## Implementation Checklist

### Strategy Definition
- [ ] `MAX_CANDLES` constant defined
- [ ] Timeframes explicitly declared
- [ ] Alignment logic documented

### Indicator Validation
- [ ] No full-history dependencies
- [ ] All indicators use fixed lookback
- [ ] Output stable regardless of history length

### Backtest Parity
- [ ] Rolling window enforced
- [ ] No future data leakage
- [ ] Same data access as live

### Multi-Timeframe
- [ ] Close time used for alignment
- [ ] Incomplete bars excluded
- [ ] HTF bar completion verified before use

### Performance
- [ ] GPU implementation attempted first
- [ ] Fallback to Numba if no GPU benefit
- [ ] No Python loops over candles
- [ ] Vectorized operations verified
- [ ] Trade simulation uses cumprod for equity curve
- [ ] Metrics use parallel scan (maximum.accumulate)

## Anti-Patterns

- Using full history in backtest
- Indicators seeded from bar 0
- Cumulative calculations from start
- All-time high/low indicators
- Aligning timeframes by open time
- Processing incomplete bars
- Python loops over candle arrays
- Sequential for-loops for trade simulation (use cumprod instead)
- Assuming backtest conditions match live
- Hardcoding window sizes
- Optimizing on full dataset without train/val/test split
- Reporting metrics without trade count
- Calculating drawdown from initial balance instead of peak
- Claiming "sequential dependencies" without attempting vectorization
