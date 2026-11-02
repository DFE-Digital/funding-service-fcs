namespace SFA.FCT.Contracts.AcceptanceTests.Infrastructure.DTO
{
    public class PeriodVolume
    {
        public PeriodVolume(string period, int? volume)
        {
            Period = period;
            Volume = volume;
        }

        public string Period { get; }

        public int? Volume { get; }

        protected bool Equals(PeriodVolume other)
        {
            return string.Equals(Period, other.Period) && Volume == other.Volume;
        }

        public override bool Equals(object obj)
        {
            if (ReferenceEquals(null, obj)) return false;
            if (ReferenceEquals(this, obj)) return true;
            if (obj.GetType() != this.GetType()) return false;
            return Equals((PeriodVolume)obj);
        }

        public override int GetHashCode()
        {
            unchecked
            {
                return ((Period?.GetHashCode() ?? 0) * 397) ^ Volume.GetHashCode();
            }
        }

        public override string ToString()
        {
            return $"Period: {Period}, Volume: {Volume}";
        }
    }
}