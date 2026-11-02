namespace SFA.FCT.Contracts.AcceptanceTests.Infrastructure.DTO
{
    public class FundingStreamPeriodDeliverableSettingInfo
    {
        public FundingStreamPeriodDeliverableSettingInfo(string fundingStreamPeriodCode, int deliverableCode, string settingName, string settingValue)
        {
            FundingStreamPeriodCode = fundingStreamPeriodCode;
            DeliverableCode = deliverableCode;
            SettingName = settingName;
            SettingValue = settingValue;
        }

        public string FundingStreamPeriodCode { get; }

        public int DeliverableCode { get; }

        public string SettingName { get; }

        public string SettingValue { get; }

        protected bool Equals(FundingStreamPeriodDeliverableSettingInfo other)
        {
            return
                string.Equals(FundingStreamPeriodCode, other.FundingStreamPeriodCode) &&
                DeliverableCode == other.DeliverableCode &&
                string.Equals(SettingName, other.SettingName) &&
                string.Equals(SettingValue, other.SettingValue);
        }

        public override bool Equals(object obj)
        {
            if (ReferenceEquals(null, obj)) return false;
            if (ReferenceEquals(this, obj)) return true;
            if (obj.GetType() != GetType()) return false;
            return Equals((FundingStreamPeriodDeliverableSettingInfo) obj);
        }

        public override int GetHashCode()
        {
            unchecked
            {
                int hashCode = FundingStreamPeriodCode.GetHashCode();
                hashCode = (hashCode*397) ^ DeliverableCode;
                hashCode = (hashCode*397) ^ SettingName.GetHashCode();
                hashCode = (hashCode*397) ^ SettingValue.GetHashCode();
                return hashCode;
            }
        }
    }
}