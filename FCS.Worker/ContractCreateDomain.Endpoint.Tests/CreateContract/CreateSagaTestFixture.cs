namespace ContractCreateDomain.Endpoint.Tests.CreateContract
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Threading.Tasks;
    using ContractManagement.DataStore.Dtos;
    using ContractManagement.DataStore.Model;
    using SFA.FCT.ContractCreateDomain.BusinessLogic.DTOs;
    using SFA.FCT.ContractCreateDomain.Implementation.Persistence.Entities;
    using SFA.FCT.CrossDomain.Integration.Entities;
    using ContractManagement.DataStore.Repositories;
    using Endpoint.Services;
    using Moq;
    using SFA.FCT.ContractCreateDomain.BusinessLogic;
    using SFA.FCT.ContractCreateDomain.BusinessLogic.Validation;
    using SFA.FCT.ContractCreateDomain.Implementation.Persistence;
    using SFA.FCT.ContractCreateDomain.Implementation.Persistence.Entities;
    using SFA.FCT.CrossDomain.Integration.Entities.ContractRequest;
    using SFA.FCT.CrossDomain.Integration.Entities.CorporateContract;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.Framework.Logging.Interfaces;
    using contractor = SFA.FCT.CrossDomain.Integration.Entities.ContractRequest.contractor;
    using contractType = SFA.FCT.CrossDomain.Integration.Entities.ContractRequest.contractType;
    using periodTypeType = SFA.FCT.CrossDomain.Integration.Entities.ContractRequest.periodTypeType;

    internal class CreateSagaTestFixture
    {
        public const string FundingType = "LEVY";
        public const string FundingPeriod = "AY1617";
        public const string ProcessId = "11111111-1111-1111-1111-111111111111";

        public CreateSagaTestFixture(bool messageNotYetProcessed = true, bool requestIsValid = true)
        {
            Processed.Setup(p => p.Add(It.IsAny<string>(), It.IsAny<ConnectionInfo>())).Returns(messageNotYetProcessed);
            Validator.Setup(v => v.Validate(It.IsAny<contractRequestType>(), It.IsAny<IEnumerable<IRule<contractRequestType>>>())).Returns(requestIsValid);
            Lookup.Setup(l => l.CreateLookupDataAndSetContractPresence(It.IsAny<contractRequestType>(), It.IsAny<ConnectionInfo>()))
                .Returns(new ContractValidationLookupData());
            FundingTypeFundingPeriods.Setup(r => r.Get(It.IsAny<string>(), It.IsAny<string>(), It.IsAny<ConnectionInfo>()))
                .Returns(new FundingTypeFundingPeriod { AllowUseOfDeliveryOrgs = true, AllowNewAmendment = true });

            NumberRequestManager.Setup(n => n.GetContractNumbers(It.IsAny<contractRequestType>(), It.IsAny<ConnectionInfo>()))
                .Returns<contractRequestType, ConnectionInfo>((request, connection) => request);
            Transformer.Setup(t => t.TransformToCorpContractType(It.IsAny<contractRequestType>()))
                .Returns(() => new ExtendedContractType
                {
                    contractNumber = "MASTER-0001",
                    contracts = new List<ExtendedContractType> { new ExtendedContractType() }
                });
            Transformer.Setup(t => t.TransformToCorpContract(It.IsAny<ExtendedContractType>()))
                .Returns(() => new SFA.FCT.CrossDomain.Integration.Entities.CorporateContract.contract
                {
                    fundingType = new SFA.FCT.CrossDomain.Integration.Entities.CorporateContract.fundingType { fundingTypeCode = FundingType },
                    period = new SFA.FCT.CrossDomain.Integration.Entities.CorporateContract.period
                    {
                        period1 = "1617",
                        periodType = new SFA.FCT.CrossDomain.Integration.Entities.CorporateContract.periodTypeType
                        {
                            periodTypeCode = periodTypeCodeType.AY
                        }
                    }
                });

            SiblingContracts.Setup(s => s.GetSiblingApprovedContractsForDocumentGeneration(
                    It.IsAny<string>(), It.IsAny<string>(), It.IsAny<string>(), It.IsAny<ConnectionInfo>()))
                .Returns(Task.FromResult<IReadOnlyCollection<ApprovedContractInfo>>(new List<ApprovedContractInfo>()));
            RelatedAllocations.Setup(r => r.EnrichWithRelatedAllocationsWhenAppropriate(
                    It.IsAny<SFA.FCT.CrossDomain.Integration.Entities.CorporateContract.contract>(), It.IsAny<ConnectionInfo>()))
                .Returns(Task.FromResult(0));
        }

        public Mock<IContractDeliverableEnricher> DeliverableEnricher { get; } = new Mock<IContractDeliverableEnricher>();

        public Mock<IContractRequestTransformer> Transformer { get; } = new Mock<IContractRequestTransformer>();

        public Mock<IContractValueAggregator> ValueAggregator { get; } = new Mock<IContractValueAggregator>();

        public Mock<ILogger> Logger { get; } = new Mock<ILogger>();

        public Mock<INumberRequestManager> NumberRequestManager { get; } = new Mock<INumberRequestManager>();

        public Mock<IOrganisationMessageEnricher> OrganisationEnricher { get; } = new Mock<IOrganisationMessageEnricher>();

        public Mock<IValidator> Validator { get; } = new Mock<IValidator>();

        public Mock<Endpoint.Infrastructure.IProcessedMessageRepository> Processed { get; } = new Mock<Endpoint.Infrastructure.IProcessedMessageRepository>();

        public Mock<Endpoint.Infrastructure.ISessionConnectionFactory> Sessions { get; } = new Mock<Endpoint.Infrastructure.ISessionConnectionFactory>();

        public Mock<Endpoint.Infrastructure.IContractOperationRules> Rules { get; } = new Mock<Endpoint.Infrastructure.IContractOperationRules>();

        public Mock<Endpoint.Infrastructure.IFundingTypeFundingPeriodQueryRepository> FundingTypeFundingPeriods { get; } = new Mock<Endpoint.Infrastructure.IFundingTypeFundingPeriodQueryRepository>();

        public Mock<Endpoint.Infrastructure.ISagaDataStorage> SagaStorage { get; } = new Mock<Endpoint.Infrastructure.ISagaDataStorage>();

        public Mock<Endpoint.Infrastructure.IContractValidationLookupDataCreator> Lookup { get; } = new Mock<Endpoint.Infrastructure.IContractValidationLookupDataCreator>();

        public Mock<IFundingTypeFundingPeriodContractTypeQueryRepository> FundingTypeFundingPeriodContractTypes { get; } = new Mock<IFundingTypeFundingPeriodContractTypeQueryRepository>();

        public Mock<ISiblingApprovedContractService> SiblingContracts { get; } = new Mock<ISiblingApprovedContractService>();

        public Mock<IRelatedAllocationEnricher> RelatedAllocations { get; } = new Mock<IRelatedAllocationEnricher>();

        public void VerifyRevisedNewRulesRequested()
        {
            Rules.Verify(r => r.GetCreateContractRevisedNewRules(
                It.IsAny<IEnumerable<FundingConfigurationDataType>>(),
                It.IsAny<IEnumerable<string>>(),
                It.IsAny<IEnumerable<string>>(),
                It.IsAny<IEnumerable<UnitOfProcurement>>(),
                It.IsAny<IEnumerable<string>>(),
                It.IsAny<IEnumerable<string>>(),
                It.IsAny<IEnumerable<string>>(),
                It.IsAny<Dictionary<string, FSCDeliverableStructureDefinitionResponse>>(),
                It.IsAny<IReadOnlyCollection<MatchingTenderAwardReferenceItem>>(),
                It.IsAny<bool>(),
                It.IsAny<IReadOnlyCollection<FundingTypePeriodFundingStreamPeriod>>(),
                It.IsAny<IReadOnlyCollection<FundingStreamPeriodLegalDeliverable>>(),
                It.IsAny<contractRequestType>(),
                true,
                It.IsAny<Func<IReadOnlyCollection<FundingTypeFundingPeriodContractTypeDto>>>(),
                It.IsAny<bool>()), Times.Once);
        }

        private Func<FundingTypeFundingPeriodDto, bool> _capturedNewAmendmentAllowedFunc;

        public Func<Func<FundingTypeFundingPeriodDto, bool>> CaptureNewAmendmentAllowedFunc()
        {
            Func<FundingTypeFundingPeriodDto, bool> captured = null;
            Rules.Setup(r => r.GetNewAmendmentContractRules(
                    It.IsAny<IEnumerable<FundingConfigurationDataType>>(),
                    It.IsAny<IEnumerable<string>>(),
                    It.IsAny<IEnumerable<string>>(),
                    It.IsAny<IEnumerable<UnitOfProcurement>>(),
                    It.IsAny<IEnumerable<string>>(),
                    It.IsAny<IEnumerable<string>>(),
                    It.IsAny<IEnumerable<string>>(),
                    It.IsAny<Dictionary<string, FSCDeliverableStructureDefinitionResponse>>(),
                    It.IsAny<IReadOnlyCollection<MatchingTenderAwardReferenceItem>>(),
                    It.IsAny<bool>(),
                    It.IsAny<IReadOnlyCollection<FundingTypePeriodFundingStreamPeriod>>(),
                    It.IsAny<IReadOnlyCollection<FundingStreamPeriodLegalDeliverable>>(),
                    It.IsAny<contractRequestType>(),
                    It.IsAny<bool>(),
                    It.IsAny<Func<IReadOnlyCollection<FundingTypeFundingPeriodContractTypeDto>>>(),
                    It.Is<Func<FundingTypeFundingPeriodDto, bool>>(f => Capture(f)),
                    It.IsAny<bool>()))
                .Returns(new List<IRule<contractRequestType>>());

            return () => _capturedNewAmendmentAllowedFunc;
        }
        private bool Capture(Func<FundingTypeFundingPeriodDto, bool> f)
        {
            _capturedNewAmendmentAllowedFunc = f;
            return true;
        }

        public static contractRequestType BuildRequest(intent crmIntent = intent.New)
        {
            return new contractRequestType
            {
                correlationInfo = new correlationInfoType { correlationId = ProcessId },
                contract = new contractType
                {
                    fundingTypeCode = FundingType,
                    contractor = new contractor { ukprn = 10000001, organisationIdentifier = "ORG1" },
                    contracts = new List<contractType>
                    {
                        new contractType
                        {
                            contractNumber = "CON-0001",
                            CRMIntent = crmIntent,
                            fundingTypeCode = FundingType,
                            period = new periodType
                            {
                                period = "1617",
                                periodType1 = new periodTypeType { periodTypeCode = "AY" }
                            }
                        }
                    }
                }
            };
        }
    }
}
