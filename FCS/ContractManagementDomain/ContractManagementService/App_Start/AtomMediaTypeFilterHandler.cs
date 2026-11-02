namespace SFA.FCT.ContractManagementService
{
    using Controllers;
    using Controllers.FundingConfigService;
    using SFA.FCT.ContractManagementService.Controllers.PaymentRequestAtomFeed;

    public class AtomMediaTypeFilterHandler// : DelegatingHandler
    {
        public static readonly string[] SupportedMediaTypes =
        {
            "APPLICATION/ATOM+XML",
            "APPLICATION/VND.SFA.CONTRACT.V1+ATOM+XML",
            "APPLICATION/VND.SFA.ALLOCATION-DELIVERY.ALLOCATION-DELIVERY-PERFORMANCE.V1+ATOM+XML",
            "APPLICATION/VND.SFA.FUNDINGCLAIMRECONCILIATION.V1+ATOM+XML",
            "APPLICATION/VND.SFA.FUNDING-POLICY.DELIVERABLE.SETTING.V1+ATOM+XML",
            "APPLICATION/VND.SFA.PAYMENTREQUESTS.V1+ATOM+XML"
        };

        public static readonly string[] AtomUrlPortions =
        {
            ContractNotificationFeedController.RoutePrefix,
            AllocationNotificationFeedController.RoutePrefix,
            FundingClaimReconciliationController.AtomRoutePrefix,
            DeliverableSettingConfigurationFeedController.RoutePrefix,
            PaymentRequestController.RoutePrefix
        };
    }
}