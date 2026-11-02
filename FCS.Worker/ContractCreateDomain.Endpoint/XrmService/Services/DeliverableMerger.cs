namespace ContractCreateDomain.Endpoint.XrmService.Services
{
    using System.Collections.Generic;
    using System.Linq;
    using DTOs;

    public static class DeliverableMerger
    {
        public static IList<Deliverable> MergeDeliverables(List<Deliverable> currentDeliverables, List<Deliverable> previousDeliverables)
        {
            foreach (var cd in currentDeliverables)
            {
                // get the previous deliverable and periods
                var previousDeliverable = previousDeliverables.FirstOrDefault(pd => pd.DeliverableCode.Equals(cd.DeliverableCode));

                // The current deliverable does not need to be on the previous allocation
                if (previousDeliverable != null)
                {
                    // only update current deliverable period where Actuals are not set
                    foreach (var cdp in cd.DeliverablePeriods.Where(d =>
                        (!d.ActualValue.HasValue || d.ActualValue.Value == 0)
                        && (!d.ActualVolume.HasValue || d.ActualVolume == 0)))
                    {
                        // only take value if it is set
                        var previousDeliverablePeriod = previousDeliverable.DeliverablePeriods.FirstOrDefault(pd =>
                            pd.Year.Equals(cdp.Year) &&
                            pd.PeriodNumber.Equals(cdp.PeriodNumber) &&
                            (pd.ActualValue.HasValue || !pd.ActualVolume.HasValue));

                        if (previousDeliverablePeriod != null)
                        {
                            if (cdp.ActualValue != previousDeliverablePeriod.ActualValue
                                || cdp.ActualVolume != previousDeliverablePeriod.ActualVolume
                                || cdp.BalancingPaymentValue != previousDeliverablePeriod.BalancingPaymentValue
                                || cdp.CappedPaymentValue != previousDeliverablePeriod.CappedPaymentValue
                                || cdp.NetPaymentValue != previousDeliverablePeriod.NetPaymentValue
                                || cdp.PaymentPosted != previousDeliverablePeriod.PaymentPosted
                                || cdp.ProfilePaymentValue != previousDeliverablePeriod.ProfilePaymentValue
                                || cdp.ReconciliationPaymentValue != previousDeliverablePeriod.ReconciliationPaymentValue
                                || cdp.CappingSubnominalId != previousDeliverablePeriod.CappingSubnominalId
                                || cdp.ProfileSubnominalId != previousDeliverablePeriod.ProfileSubnominalId
                                || cdp.ReconcilliationSubnominalId != previousDeliverablePeriod.ReconcilliationSubnominalId)
                            {
                                cdp.ActualValue = previousDeliverablePeriod.ActualValue;
                                cdp.ActualVolume = previousDeliverablePeriod.ActualVolume;
                                cdp.BalancingPaymentValue = previousDeliverablePeriod.BalancingPaymentValue;
                                cdp.CappedPaymentValue = previousDeliverablePeriod.CappedPaymentValue;
                                cdp.NetPaymentValue = previousDeliverablePeriod.NetPaymentValue;
                                cdp.PaymentPosted = previousDeliverablePeriod.PaymentPosted;
                                cdp.ProfilePaymentValue = previousDeliverablePeriod.ProfilePaymentValue;
                                cdp.ReconciliationPaymentValue = previousDeliverablePeriod.ReconciliationPaymentValue;
                                cdp.CappingSubnominalId = previousDeliverablePeriod.CappingSubnominalId;
                                cdp.ProfileSubnominalId = previousDeliverablePeriod.ProfileSubnominalId;
                                cdp.ReconcilliationSubnominalId = previousDeliverablePeriod.ReconcilliationSubnominalId;
                                cdp.Modified = true;
                            }
                        }
                    }
                }
            }

            return currentDeliverables;
        }
    }
}
