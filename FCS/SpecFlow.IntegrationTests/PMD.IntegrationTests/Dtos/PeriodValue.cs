namespace PMD.IntegrationTests.Dtos
{
    using System;
    using System.Globalization;

    public class PeriodValue
    {
        public PeriodValue(string period, decimal? value)
        {
            Period = period;
            Value = value;
        }

        /// <remarks> Jan-20 format</remarks>
        public string Period { get; }

        public decimal? Value { get; }

        public string PeriodAsYYYYMM => DateTime.ParseExact($"01-{Period}", "dd-MMM-yy", CultureInfo.InvariantCulture).ToString("yyyyMM");

        protected bool Equals(PeriodValue other)
        {
            return string.Equals(Period, other.Period) && Value.GetValueOrDefault(0) == other.Value.GetValueOrDefault(0);
        }

        public override bool Equals(object obj)
        {
            if (ReferenceEquals(null, obj)) return false;
            if (ReferenceEquals(this, obj)) return true;
            if (obj.GetType() != this.GetType()) return false;
            return Equals((PeriodValue)obj);
        }

        public override int GetHashCode()
        {
            unchecked
            {
                return ((Period != null ? Period.GetHashCode() : 0) * 397) ^ Value.GetHashCode();
            }
        }

        public override string ToString()
        {
            return $"Period: {Period}, Value: {Value}";
        }
    }
}
