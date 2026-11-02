namespace SFA.FCT.DocumentsDomain.DocumentGeneration.DocumentDefiner.DocumentPartCreators
{
    public class PeriodTotalValue
    {
        public PeriodTotalValue(int period, decimal value)
        {
            Period = period;
            Value = value;
        }

        public int Period { get; }

        public decimal? Value { get; private set; }

        public void RemoveValue()
        {
            Value = null;
        }
    }
}
