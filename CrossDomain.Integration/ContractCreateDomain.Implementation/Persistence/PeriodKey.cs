namespace SFA.FCT.ContractCreateDomain.Implementation.Persistence
{
    using System;
    using CrossDomain.Integration.Entities.CorporateContract;

    public class PeriodKey
    {
        public PeriodKey(string periodName, periodTypeCodeType periodTypeCodeType)
        {
            if (string.IsNullOrEmpty(periodName))
            {
                throw new ArgumentException("The period name is required");
            }

            PeriodName = periodName;
            PeriodTypeCodeType = periodTypeCodeType;
        }

        /// <summary>
        /// Gets or sets the PeriodName - e.g. 1516
        /// </summary>
        public string PeriodName { get; private set; }

        public periodTypeCodeType PeriodTypeCodeType { get; private set; }

        public override bool Equals(object obj)
        {
            PeriodKey comparisonObject = obj as PeriodKey;
            bool isEqual = false;

            if (comparisonObject != null)
            {
                isEqual = PeriodName.Equals(comparisonObject.PeriodName) &&
                          PeriodTypeCodeType.Equals(comparisonObject.PeriodTypeCodeType);
            }

            return isEqual;
        }

        public override int GetHashCode()
        {
            return PeriodName.GetHashCode() ^ PeriodTypeCodeType.GetHashCode();
        }
    }
}
