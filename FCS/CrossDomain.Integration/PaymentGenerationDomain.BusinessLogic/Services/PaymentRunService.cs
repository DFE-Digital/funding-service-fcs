namespace PaymentGenerationDomain.BusinessLogic.Services
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Text;
    using System.Threading.Tasks;
    using PaymentGenerationDomain.Common;
    using PaymentGenerationDomain.Integration.DataStore.Dtos;
    using PaymentGenerationDomain.Integration.DataStore.Model;
    using PaymentGenerationDomain.Integration.DataStore.Repositories;
    using SFA.FCT.AllocationDeliveryDomain.Common.BusinessLogic.Repository;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.Framework.Logging.Interfaces;
    using CorporateSchema = SFA.FCT.CrossDomain.Integration.Entities.CorporatePaymentGeneration;

    public class PaymentRunService : IPaymentRunService
    {
        private readonly IPaymentCorpSchemaMapper _paymentCorpSchemaMapper;
        private readonly IPaymentGenerationXmlValidator _paymentGenerationXmlValidator;
        private readonly ILogger _logger;
        private readonly IDataAccessManager _dataAccessManager;
        private readonly IMonitoringDeliverableStore _monitoringDeliverableStore;
        private readonly IPaymentBatchFeedItemCommandRepository _paymentBatchFeedItemCommandRepository;
        private readonly IFundingStreamPeriodQueryRepository _fundingStreamPeriodQueryRepository;

        public PaymentRunService(
            IPaymentCorpSchemaMapper paymentCorpSchemaMapper,
            IPaymentGenerationXmlValidator paymentGenerationXmlValidator,
            ILogger logger,
            IDataAccessManager dataAccessManager,
            IMonitoringDeliverableStore monitoringDeliverableStore,
            IPaymentBatchFeedItemCommandRepository paymentBatchFeedItemCommandRepository,
            IFundingStreamPeriodQueryRepository fundingStreamPeriodQueryRepository)
        {
            _paymentCorpSchemaMapper = paymentCorpSchemaMapper;
            _paymentGenerationXmlValidator = paymentGenerationXmlValidator;
            _logger = logger;
            _dataAccessManager = dataAccessManager;
            _monitoringDeliverableStore = monitoringDeliverableStore;
            _paymentBatchFeedItemCommandRepository = paymentBatchFeedItemCommandRepository;
            _fundingStreamPeriodQueryRepository = fundingStreamPeriodQueryRepository;
        }

        public async Task PublishPaymentPeriod(
            PaymentTimetable paymentTimetable,
            Func<CorporateSchema.PaymentPeriod, int, Task> paymentPeriodPublished,
            Func<string, Task> paymentPeriodValidationFailed,
            ConnectionInfo connectionInfo)
        {
            IReadOnlyCollection <SubnominalAggregationDto> payments = _dataAccessManager.UpdateAndGetPaymentsForPaymentRun(paymentTimetable.FundingStreamPeriodCode, paymentTimetable.CalendarPeriod, connectionInfo);

            FundingStreamPeriod fundingStreamPeriod =
                await _fundingStreamPeriodQueryRepository.GetFundingStreamPeriodWithFundingStream(paymentTimetable
                    .FundingStreamPeriodCode);

            var esfAllocationData = _monitoringDeliverableStore.GetEsfAllocationData(payments.Select(x => x.AllocationNumber).ToList(), connectionInfo);
            CorporateSchema.PaymentPeriod corpPaymentPeriod = _paymentCorpSchemaMapper.MapSubnominalAggregationToCorpPaymentSchema(
                subnominalAggregations: payments,
                paymentTimetableDetails: paymentTimetable,
                esfAllocationData: esfAllocationData,
                agency: fundingStreamPeriod.FundingStream.AgencyCode,
                fundingStreamPeriodStartDate: fundingStreamPeriod.StartDate, 
                fundingStreamPeriodEndDate: fundingStreamPeriod.EndDate, 
                financeShortCode: fundingStreamPeriod.FundingStream.FinanceShortCode
                );

            _logger.LogInformation(
                PaymentGenerationDomainLoggingEventId.TransformingPaymentsToCorporateSchema,
                "Transforming payments to Corporate Schema for for funding stream period : {0}, Calendar Period : {1} ",
                paymentTimetable.FundingStreamPeriodCode,
                paymentTimetable.CalendarPeriod);

            if (_paymentGenerationXmlValidator.Validate(corpPaymentPeriod))
            {
                PaymentBatchFeedItem paymentBatchFeedItem = PaymentBatchFeedItem.Create(
                    corporatePaymentPeriod: corpPaymentPeriod,
                    fundingStreamPeriod: paymentTimetable.FundingStreamPeriodCode,
                    linkCodeSuffix: paymentTimetable.LinkCodeSuffix);

                PaymentBatchFeedItemAddResult result = await _paymentBatchFeedItemCommandRepository.AddItem(paymentBatchFeedItem, connectionInfo: connectionInfo);

                _logger.LogInformation(
                    PaymentGenerationDomainLoggingEventId.PublishedPaymentToAtomFeed,
                    $"Payment Period valid: {paymentBatchFeedItem}. Publish result: {result}.");

                if (result == PaymentBatchFeedItemAddResult.Added)
                {
                    await paymentPeriodPublished(corpPaymentPeriod, paymentBatchFeedItem.Id).ConfigureAwait(continueOnCapturedContext: false);
                }
            }
            else
            {
                var sb = new StringBuilder("The resultant CODAAdapter xml failed schema validation: " + Environment.NewLine);
                _paymentGenerationXmlValidator.ErrorMessages.ForEach(
                    x =>
                    {
                        sb.Append("LineNumber:");
                        sb.Append(x.LineNumber);
                        sb.Append("LinePosition:");
                        sb.Append(x.LinePosition);
                        sb.Append("ErrorMessage:");
                        sb.Append(x.ErrorMessage);
                        sb.Append(Environment.NewLine);
                    });

                await paymentPeriodValidationFailed(sb.ToString()).ConfigureAwait(continueOnCapturedContext: false);
            }
        }
    }
}
