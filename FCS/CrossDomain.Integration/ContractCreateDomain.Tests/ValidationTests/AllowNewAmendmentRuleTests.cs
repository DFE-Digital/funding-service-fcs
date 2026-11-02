namespace ContractCreateDomain.Tests.ValidationTests
{
    using System.Collections.Generic;
    using System.Linq;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.ContractCreateDomain.BusinessLogic.Validation.Rules;
    using SFA.FCT.CrossDomain.Integration.Entities.ContractRequest;
    using FundingTypeFundingPeriodDto = ContractManagement.DataStore.Dtos.FundingTypeFundingPeriodDto;

    [TestClass]
    public class AllowNewAmendmentRuleTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void AllowNewAmendmentRule_ShouldReturnFailureWithCorrelationId_WhenNewAmendmentIsNotAllowed()
        {
            // arrange
            bool IsNewAmendmentAllow(FundingTypeFundingPeriodDto ftfp) => false;

            // arrange
            const string fundingTypeCode = "EDSK";
            const string contractType = "Contract for Services";

            contractRequestType masterContract = new contractRequestType
            {
                contract = new contractType
                {
                    contracts = new List<contractType>
                    {
                        new contractType
                        {
                            contractType1 = contractType,
                            fundingTypeCode = fundingTypeCode,
                            period = new periodType
                            {
                                period = "1920",
                                periodType1 = new periodTypeType
                                {
                                    periodTypeCode = "AY"
                                }
                            }
                        }
                    }
                }
            };

            AllowNewAmendmentRule rule = new AllowNewAmendmentRule(IsNewAmendmentAllow);

            // act
            IEnumerable<string> failures = rule.GetFailuresForItem(masterContract);

            // assert
            Assert.AreEqual(1, failures.Count(), "The number of failures in incorrect");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void AllowNewAmendmentRule_ShouldReturnNoFailures_WhenNewAmendmentIsAllowed()
        {
            // arrange
            bool IsNewAmendmentAllow(FundingTypeFundingPeriodDto ftfp) => true;

            // arrange
            const string fundingTypeCode = "EDSK";
            const string contractType = "Contract for Services";

            contractRequestType masterContract = new contractRequestType
            {
                contract = new contractType
                {
                    contracts = new List<contractType>
                    {
                        new contractType
                        {
                            contractType1 = contractType,
                            fundingTypeCode = fundingTypeCode,
                            period = new periodType
                            {
                                period = "1920",
                                periodType1 = new periodTypeType
                                {
                                    periodTypeCode = "AY"
                                }
                            }
                        }
                    }
                }
            };

            AllowNewAmendmentRule rule = new AllowNewAmendmentRule(IsNewAmendmentAllow);

            // act
            IEnumerable<string> failures = rule.GetFailuresForItem(masterContract);

            // assert
            Assert.AreEqual(0, failures.Count(), "The number of failures in incorrect");
        }
    }
}
