namespace SFA.FCT.CrossDomain.Integration.Entities.CorporateContract
{
    using System.Diagnostics.CodeAnalysis;

    [SuppressMessage("StyleCop.CSharp.NamingRules", "SA1300:ElementMustBeginWithUpperCaseLetter",
        Justification = "as per schema")]
    public partial class contractDeliverablePeriodsTypeContractDeliverablePeriod
    {
        public decimal GetDeliverablePeriodValue(bool aggregateOnly)
        {
            decimal value = 0;

            if (aggregate == aggregateOnly)
            {
                if (plannedValue == 0 && plannedVolume != 0 && unitCost != 0)
                {
                    value = plannedVolume * unitCost;
                }
                else
                {
                    value = plannedValue;
                }
            }

            return value;
        }

        public void CalculateAndSetPlannedValue()
        {
            plannedValue = CalculatePlannedValue();
        }

        private decimal CalculatePlannedValue()
        {
            decimal value = 0;

            if (plannedValue == 0 && plannedVolume != 0 && unitCost != 0)
            {
                value = plannedVolume * unitCost;
            }
            else
            {
                value = plannedValue;
            }

            return value;
        }
    }
}
