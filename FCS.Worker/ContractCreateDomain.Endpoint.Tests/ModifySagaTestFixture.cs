namespace ContractCreateDomain.Endpoint.Tests
{
    using System;
    using System.Collections.Generic;
    using System.Threading.Tasks;
    using ContractManagement.DataStore.Model;
    using ContractManagement.DataStore.Services;
    using Endpoint.Services;
    using Moq;
    using SFA.FCT.ContractCreateDomain.BusinessLogic;
    using SFA.FCT.ContractCreateDomain.BusinessLogic.Services;
    using SFA.FCT.ContractCreateDomain.BusinessLogic.Validation;
    using SFA.FCT.ContractCreateDomain.Implementation.Persistence;
    using SFA.FCT.ContractCreateDomain.Implementation.Persistence.Entities;
    using SFA.FCT.CrossDomain.Integration.Entities.ContractRequest;
    using SFA.FCT.CrossDomain.Integration.Entities.CorporateContract;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.Framework.Logging.Interfaces;
    using contractType = SFA.FCT.CrossDomain.Integration.Entities.ContractRequest.contractType;

    internal class ModifySagaTestFixture
    {
        public const string CorpFundingType = "LEVY";
        public const string ChildContractNumber = "CON-0001";

        public ModifySagaTestFixture(
            bool messageNotYetProcessed = true,
            PreviousContractMergeResult mergeResult = PreviousContractMergeResult.PreviousContractMerged,
            bool firstLevelValid = true,
            bool secondLevelValid = true)
        {
            Processed.Setup(p => p.Add(It.IsAny<string>(), It.IsAny<ConnectionInfo>())).Returns(messageNotYetProcessed);
            Merger.Setup(m => m.MergeOptionalFieldsFromPreviousContract(It.IsAny<contractRequestType>())).Returns(mergeResult);
            Lookup.Setup(l => l.CreateLookupDataAndSetContractPresence(It.IsAny<contractRequestType>(), It.IsAny<ConnectionInfo>()))
                .Returns(new ContractValidationLookupData());
            Validator.Setup(v => v.Validate(It.IsAny<contractRequestType>(), FirstLevelRules)).Returns(firstLevelValid);
            Validator.Setup(v => v.Validate(It.IsAny<contractRequestType>(), SecondLevelRules)).Returns(secondLevelValid);

            ContractsManager.Setup(c => c.GetLatestContract(It.IsAny<string>(), It.IsAny<IEnumerable<string>>()))
                .Returns(() => new contractType { contracts = new List<contractType> { new contractType { contractNumber = ChildContractNumber } } });
            Masher.Setup(m => m.Mash(It.IsAny<contractType>(), It.IsAny<contractType>()))
                .Returns<contractType, contractType>((existing, imported) => imported);

            Transformer.Setup(t => t.TransformToCorpContractType(It.IsAny<contractRequestType>()))
                .Returns(() => new ExtendedContractType
                {
                    contractNumber = "MASTER-0001",
                    contracts = new List<ExtendedContractType> { new ExtendedContractType { contractNumber = ChildContractNumber } }
                });
            Transformer.Setup(t => t.TransformToCorpContract(It.IsAny<ExtendedContractType>()))
                .Returns(() => new SFA.FCT.CrossDomain.Integration.Entities.CorporateContract.contract
                {
                    contractNumber = ChildContractNumber,
                    fundingType = new SFA.FCT.CrossDomain.Integration.Entities.CorporateContract.fundingType { fundingTypeCode = CorpFundingType },
                    period = new SFA.FCT.CrossDomain.Integration.Entities.CorporateContract.period
                    {
                        period1 = "1617",
                        periodType = new SFA.FCT.CrossDomain.Integration.Entities.CorporateContract.periodTypeType
                        {
                            periodTypeCode = periodTypeCodeType.AY
                        }
                    }
                });

            Sibling.Setup(s => s.GetSiblingApprovedContractsForDocumentGeneration(
                    It.IsAny<string>(), It.IsAny<string>(), It.IsAny<string>(), It.IsAny<string>(), It.IsAny<ConnectionInfo>()))
                .Returns(Task.FromResult<IReadOnlyCollection<ApprovedContractInfo>>(new List<ApprovedContractInfo>()));
            Related.Setup(r => r.EnrichWithRelatedAllocationsWhenAppropriate(
                    It.IsAny<SFA.FCT.CrossDomain.Integration.Entities.CorporateContract.contract>(), It.IsAny<ConnectionInfo>()))
                .Returns(Task.FromResult(0));
            LastApproved.Setup(l => l.GetLatestCreatedDateForNonNotificationApprovedContract(It.IsAny<string>(), It.IsAny<ConnectionInfo>()))
                .Returns(Task.FromResult<DateTime?>(null));
        }

        public List<IRule<contractRequestType>> FirstLevelRules { get; } = new List<IRule<contractRequestType>> { Mock.Of<IRule<contractRequestType>>() };

        public List<IRule<contractRequestType>> SecondLevelRules { get; } = new List<IRule<contractRequestType>> { Mock.Of<IRule<contractRequestType>>() };

        public List<contractType> IncrementedContracts { get; } = new List<contractType>();

        public Mock<ILogger> Logger { get; } = new Mock<ILogger>();

        public Mock<Endpoint.Infrastructure.IContractValidationLookupDataCreator> Lookup { get; } = new Mock<Endpoint.Infrastructure.IContractValidationLookupDataCreator>();

        public Mock<IValidator> Validator { get; } = new Mock<IValidator>();

        public Mock<IOrganisationMessageEnricher> OrganisationEnricher { get; } = new Mock<IOrganisationMessageEnricher>();

        public Mock<IMasher> Masher { get; } = new Mock<IMasher>();

        public Mock<IContractRequestTransformer> Transformer { get; } = new Mock<IContractRequestTransformer>();

        public Mock<IContractDeliverableEnricher> DeliverableEnricher { get; } = new Mock<IContractDeliverableEnricher>();

        public Mock<IContractValueAggregator> ValueAggregator { get; } = new Mock<IContractValueAggregator>();

        public Mock<IContractsManager> ContractsManager { get; } = new Mock<IContractsManager>();

        public Mock<INumberRequestManager> NumberRequestManager { get; } = new Mock<INumberRequestManager>();

        public Mock<Endpoint.Infrastructure.IProcessedMessageRepository> Processed { get; } = new Mock<Endpoint.Infrastructure.IProcessedMessageRepository>();

        public Mock<IPreviousContractMerger> Merger { get; } = new Mock<IPreviousContractMerger>();

        public Mock<Endpoint.Infrastructure.ISessionConnectionFactory> Sessions { get; } = new Mock<Endpoint.Infrastructure.ISessionConnectionFactory>();

        public Mock<ILegalDeliverableService> LegalDeliverables { get; } = new Mock<ILegalDeliverableService>();

        public Mock<ICheckForContractChangeService> CheckForChange { get; } = new Mock<ICheckForContractChangeService>();

        public Mock<ISiblingApprovedContractService> Sibling { get; } = new Mock<ISiblingApprovedContractService>();

        public Mock<IRelatedAllocationEnricher> Related { get; } = new Mock<IRelatedAllocationEnricher>();

        public Mock<ILastApprovedContractCreationDateService> LastApproved { get; } = new Mock<ILastApprovedContractCreationDateService>();

        public ModifyContractSaga CreateModifySaga()
        {
            return new ModifyContractSaga(
                Logger.Object,
                Lookup.Object,
                Validator.Object,
                OrganisationEnricher.Object,
                Masher.Object,
                Transformer.Object,
                DeliverableEnricher.Object,
                ValueAggregator.Object,
                ContractsManager.Object,
                NumberRequestManager.Object,
                Processed.Object,
                Merger.Object,
                Sessions.Object,
                IncrementedContracts.Add,
                LegalDeliverables.Object,
                1,
                CheckForChange.Object,
                Sibling.Object,
                Related.Object,
                LastApproved.Object);
        }

        public IEnumerable<IRule<contractRequestType>> GetFirstLevelRules(contractRequestType request, ContractValidationLookupData lookupData, ConnectionInfo connection)
        {
            return FirstLevelRules;
        }

        public IEnumerable<IRule<contractRequestType>> GetSecondLevelRules(
            contractRequestType request,
            ContractValidationLookupData lookupData,
            IReadOnlyCollection<ContractIdentityInfo> identityInfos,
            ConnectionInfo connection)
        {
            return SecondLevelRules;
        }
    }
}
