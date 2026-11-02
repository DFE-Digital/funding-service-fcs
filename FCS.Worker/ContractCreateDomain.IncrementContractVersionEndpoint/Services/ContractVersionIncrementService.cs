namespace ContractCreateDomain.IncrementContractVersionEndpoint.Services
{
    using System;
    using SFA.FCT.ContractCreateDomain.BusinessLogic;
    using SFA.FCT.ContractManagementService.Common;
    using SFA.FCT.CrossDomain.Integration.Entities.ContractRequest;
    using SFA.FCT.CrossDomain.Integration.Entities.CorporateContract;
    using contractType = SFA.FCT.CrossDomain.Integration.Entities.ContractRequest.contractType;
    using System.Linq;
    using SFA.FCT.ContractCreateDomain.Implementation.Persistence;

    public class ContractVersionIncrementService : IContractVersionIncrementService
    {
        private readonly IContractsManager _contractsManager;
        private readonly IContractDeliverableEnricher _contractDeliverableEnricher;
        private readonly IContractRequestTransformer _contractRequestTransformer;
        private readonly IContractValueAggregator _contractValueAggregator;

        public ContractVersionIncrementService(
            IContractsManager contractsManager,
            IContractDeliverableEnricher contractDeliverableEnricher,
            IContractRequestTransformer contractRequestTransformer,
            IContractValueAggregator contractValueAggregator)
        {
            _contractsManager = contractsManager;
            _contractDeliverableEnricher = contractDeliverableEnricher;
            _contractRequestTransformer = contractRequestTransformer;
            _contractValueAggregator = contractValueAggregator;
        }

        public ExtendedContractType CreateAmendedContractVersionIfNotAlreadyCreated(ContractIdentifier contractIdentifier, AmendmentType amendmentType, bool isNonFinancialAmendment)
        {
            Guid mostRecentContractId = _contractsManager.GetMostRecentContractId(contractIdentifier.ContractNumber, contractIdentifier.VersionNumber);

            contractType mostRecentContract = _contractsManager.GetContractForId(mostRecentContractId);

            UpdateVersionForAmendment(mostRecentContract, isNonFinancialAmendment);

            ExtendedContractType extendedContract =
                _contractRequestTransformer.TransformToCorpContractType(new contractRequestType
                {
                    contract = mostRecentContract
                });

            var childContract = extendedContract.contracts.First();

            if (!_contractsManager.DoesContractVersionExist(contractIdentifier.ContractNumber, childContract.contractVersionNumber))
            {
                _contractDeliverableEnricher.Enrich(extendedContract);

                _contractValueAggregator.Aggregate(extendedContract);
                SetValueVariance(extendedContract, valueVariance: 0);

                childContract.amendmentType = amendmentType.ToString();
                SetReasonForAmendment(extendedContract, reasonForAmendment: null);

                return extendedContract;
            }

            return null;
        }

        public void UpdateVersionForAmendment(contractType masterContract, bool isNonFinancialAmendment)
        {
            Func<string, Guid?> getPreviousVersionId = contractNumber => _contractsManager.GetLatestVersionContractId(contractNumber);
            if (isNonFinancialAmendment)
            {
                getPreviousVersionId = contractNumber => _contractsManager.GetApprovedContractId(contractNumber);
            }

            masterContract.contracts.ForEach(c =>
            {
                c.contractVersionNumber = _contractsManager.GetMaximumContractVersionNumber(c.contractNumber) + 1;
                c.contractSubVersionNumber = 0;
                c.PreviousVersionId = getPreviousVersionId(c.contractNumber);
                c.Id = null;
            });
        }

        private void SetValueVariance(ExtendedContractType contractType, decimal valueVariance)
        {
            contractType.contracts.ForEach(c =>
            {
                c.ValueVariation = valueVariance;
                c.contractAllocations.ForEach(a => a.ValueVariation = valueVariance);
            });
        }

        private static void SetReasonForAmendment(ExtendedContractType contractType, string reasonForAmendment)
        {
            contractType.contracts.ForEach(c =>
            {
                c.contractAllocations.ForEach(a => a.reasonForAmendment = reasonForAmendment);
            });
        }
    }
}