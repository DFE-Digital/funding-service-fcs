namespace FCT.Operations.FundingConfirmationReport.Extensions
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using DTOs;

    public static class NetPaymentInfoCollectionExtensions
    {
        public static IReadOnlyCollection<FspAllocationAndFunded> ToFspAllocationAndFundedItems(
            this IEnumerable<NetPaymentInfo> deliverablePaymentInfos, Func<string, FspInfo> getFspInfo, PaymentMethod paymentMethod)
        {
            return deliverablePaymentInfos
                .Select(p =>
                {
                    var fspInfo = getFspInfo(p.FspCode);
                    return new FspAllocationAndFunded(
                        p.FspCode,
                        fspInfo.Description,
                        p.NetPayment,
                        0,
                        fspInfo.Order,
                        paymentMethod);
                })
                .ToList();
        }
    }
}
