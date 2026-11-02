using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading;
using Microsoft.Xrm.Sdk;
using SFA.FCT.Xrm.TestFramework.Utils;
using Timer = System.Timers.Timer;


namespace SFA.FCT.Xrm.TestFramework.Steps
{
    public class NewContractNumberStep
    {
        private readonly AcceptanceTestUtils _acceptanceTestUtils;

        public NewContractNumberStep(string userName)
        {
            _acceptanceTestUtils = new AcceptanceTestUtils(userName);
        }

        public string GetContractNumber()
        {
            return _acceptanceTestUtils.GenerateContractNumberInCrm();
        }

        public List<string> GetContractsNumbersForFundingType(string fundingType)
        {
            List<Entity> contracts = _acceptanceTestUtils.GetContractsInCrmForFundingType(fundingType);

            List<string> contractNumbersList = new List<string>();
            foreach (Entity contract in contracts)
            {
                contractNumbersList.Add(contract.Attributes["ContractNumber"].ToString());
            }
            contractNumbersList.Sort((a, b) => -1* a.CompareTo(b));
            return contractNumbersList;
        }

    }
}