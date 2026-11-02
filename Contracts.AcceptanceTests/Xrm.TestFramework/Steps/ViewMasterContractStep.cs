namespace SFA.FCT.Xrm.TestFramework.Steps
{
    using System.Collections.Generic;
    using Microsoft.Xrm.Sdk;
    using SFA.FCT.Xrm.TestFramework.Utils;

    public class ViewMasterContractStep
    {
        private readonly AcceptanceTestUtils _acceptanceTestUtils;
        private IList<Entity> _initialMatchingEntities;

        public ViewMasterContractStep(string userName)
        {
            _acceptanceTestUtils = new AcceptanceTestUtils(userName);
        }

        public void GetContractEntitiesByContractNumber(string contractNumber)
        {
            _initialMatchingEntities = _acceptanceTestUtils.GetContractsInCrmForContractNumberAndWaitIfNotFound(contractNumber);
        }

        public int GetMatchingEntitiesCount()
        {
            return _initialMatchingEntities.Count;
        }

    }
}
