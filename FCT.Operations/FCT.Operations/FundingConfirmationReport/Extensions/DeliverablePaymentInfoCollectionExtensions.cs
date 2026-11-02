namespace FCT.Operations.FundingConfirmationReport.Extensions
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using DTOs;

    public static class DeliverablePaymentInfoCollectionExtensions
    {
        public static IReadOnlyCollection<FspAllocationAndFunded> ToFspAllocationAndFundedItems(
            this IEnumerable<DeliverablePaymentInfo> deliverablePaymentInfos, Func<string, FspInfo> getFspInfo, PaymentMethod paymentMethod)
        {
            return deliverablePaymentInfos
                .Select(p =>
                {
                    var fspInfo = getFspInfo(p.FspCode);
                    return new FspAllocationAndFunded(
                        p.FspCode,
                        fspInfo.Description,
                        p.ValueA,
                        p.ValueB,
                        fspInfo.Order,
                        paymentMethod);
                })
                .ToList();
        }
    }
}
