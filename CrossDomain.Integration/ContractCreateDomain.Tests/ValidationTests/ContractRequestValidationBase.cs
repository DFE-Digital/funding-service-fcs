namespace ContractCreateDomain.Tests.ValidationTests
{
    using System.Collections.Generic;
    using SFA.FCT.CrossDomain.Integration.Entities;
    using SFA.FCT.CrossDomain.Integration.Entities.ContractRequest;
    using UnitTests.Common;

    public abstract class ContractRequestValidationBase
    {
        protected readonly contractRequestType Contract;
        protected readonly contractRequestType EsfContract;
        protected readonly IDictionary<string, FSCDeliverableStructureDefinitionResponse> DeliverableMetaData;

        protected ContractRequestValidationBase()
        {
            DeliverableMetaData = new Dictionary<string, FSCDeliverableStructureDefinitionResponse>();

            Contract = TestResource.FromXml<contractRequestType>("ContractCreateDomain.Tests.Resources", "ContractRequest.xml");
            EsfContract = TestResource.FromXml<contractRequestType>("ContractCreateDomain.Tests.Resources", "ContractRequest_ESF.xml");

            AddDeliverableMetaDataForContractsAllocations(Contract);
            AddDeliverableMetaDataForContractsAllocations(EsfContract);
        }

        protected contractRequestType GetUpdateDraftEfaContract()
        {
            return TestResource.FromJson<contractRequestType>("ContractCreateDomain.Tests.Resources", "contractRequestType_EFA_UpdateDraft.json");
        }

        private void AddDeliverableMetaDataForContractsAllocations(contractRequestType contract)
        {
            foreach (contractAllocation allocation in contract.GetAllocations())
            {
                switch (allocation.fundingStreamCode)
                {
                    case "24+ ALLF":
                        allocation.fundingStreamPeriodCode = "24+ALLF1516";
                        break;
                    case "24+ ALLBC":
                        allocation.fundingStreamPeriodCode = "24+ALLBC1516";
                        break;
                    case "24+ ALLB":
                        allocation.fundingStreamPeriodCode = "24+ALLB1516";
                        break;
                }

                if (!DeliverableMetaData.ContainsKey(allocation.fundingStreamPeriodCode))
                {
                    DeliverableMetaData.Add(allocation.fundingStreamPeriodCode, GetDeliverableMetaData(allocation.fundingStreamPeriodCode));
                }
            }
        }

        protected FSCDeliverableStructureDefinitionResponse GetDeliverableMetaData(string fundingStreamPeriodCode)
        {
            return TestResource.FromXml<FSCDeliverableStructureDefinitionResponse>(
                "ContractCreateDomain.Tests", $@"Resources.FSCDeliverableData{fundingStreamPeriodCode}.xml");
        }
    }
}