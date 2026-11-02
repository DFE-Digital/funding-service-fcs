namespace ContractCreateDomain.Tests.ValidationTests
{
    using System.Collections.Generic;
    using System.Linq;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.ContractCreateDomain.BusinessLogic.DTOs;
    using SFA.FCT.ContractCreateDomain.BusinessLogic.Validation.Rules;
    using SFA.FCT.CrossDomain.Integration.Entities.ContractRequest;
    using UnitTests.Common;

    [TestClass]
    public class ContractTypeForFundingTypeFundingPeriodRuleTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void ContractTypeForFundingTypeFundingPeriodRule_ShouldReturnFailedCorrelationIdForContractWhenContractTypeInfoIncorrect()
        {
            // arrange
            const string fundingTypeCode = "EDSK";
            const string fundingPeriod = "AY1920";
            const string contractType = "Contract for Services";

            IReadOnlyCollection<FundingTypeFundingPeriodContractTypeDto> GetContractTypesForFundingInfo() => new List<FundingTypeFundingPeriodContractTypeDto>
            {
                new FundingTypeFundingPeriodContractTypeDto(fundingTypeCode, fundingPeriod, contractType)
            };

            contractRequestType masterContract = new contractRequestType
            {
                contract = new contractType
                {
                    contracts = new List<contractType>
                    {
                        new contractType
                        {
                            contractType1 = "X",
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

            ContractTypeForFundingTypeFundingPeriodRule rule = new ContractTypeForFundingTypeFundingPeriodRule(GetContractTypesForFundingInfo);

            // act
            IEnumerable<string> failures = rule.GetFailuresForItem(masterContract);

            // assert
            Assert.AreEqual(1, failures.Count(), "The number of failures is incorrect");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ContractTypeForFundingTypeFundingPeriodRule_ShouldReturnPositively_WhenFundingTypeCodeAndPeriodIsNotInList()
        {
            // arrange
            const string fundingTypeCode = "EDSK";
            const string fundingPeriod = "AY1920";
            const string contractType = "Contract for Services";

            IReadOnlyCollection<FundingTypeFundingPeriodContractTypeDto> GetContractTypesForFundingInfo() => new List<FundingTypeFundingPeriodContractTypeDto>
            {
                new FundingTypeFundingPeriodContractTypeDto(fundingTypeCode, fundingPeriod, contractType)
            };

            contractRequestType masterContract = new contractRequestType
            {
                contract = new contractType
                {
                    contracts = new List<contractType>
                    {
                        new contractType
                        {
                            contractType1 = "X",
                            fundingTypeCode = "Some Other",
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

            ContractTypeForFundingTypeFundingPeriodRule rule = new ContractTypeForFundingTypeFundingPeriodRule(GetContractTypesForFundingInfo);

            // act
            IEnumerable<string> failures = rule.GetFailuresForItem(masterContract);

            // assert
            Assert.AreEqual(0, failures.Count(), "The number of failures is incorrect");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ContractTypeForFundingTypeFundingPeriodRule_ShouldReturnPositively_WhenFundingTypeCodeAndPeriodAndContractTypeIsInList()
        {
            // arrange
            const string fundingTypeCode = "EDSK";
            const string fundingPeriod = "AY1920";
            const string contractType = "Contract for Services";

            IReadOnlyCollection<FundingTypeFundingPeriodContractTypeDto> GetContractTypesForFundingInfo() => new List<FundingTypeFundingPeriodContractTypeDto>
            {
                new FundingTypeFundingPeriodContractTypeDto(fundingTypeCode, fundingPeriod, contractType)
            };

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

            ContractTypeForFundingTypeFundingPeriodRule rule = new ContractTypeForFundingTypeFundingPeriodRule(GetContractTypesForFundingInfo);

            // act
            IEnumerable<string> failures = rule.GetFailuresForItem(masterContract);

            // assert
            Assert.AreEqual(0, failures.Count(), "The number of failures is incorrect");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ContractTypeForFundingTypeFundingPeriodRule_ShouldFail_WhenContractTypeNotSupportedFromFile()
        {
            // arrange
            const string fundingTypeCode = "EDSK";
            const string fundingPeriod = "AY1920";
            const string contractType = "Contract for Services";

            IReadOnlyCollection<FundingTypeFundingPeriodContractTypeDto> GetContractTypesForFundingInfo() => new List<FundingTypeFundingPeriodContractTypeDto>
            {
                new FundingTypeFundingPeriodContractTypeDto(fundingTypeCode, fundingPeriod, contractType)
            };

            contractRequestType masterContract = GetContractRequestTypeFromFile();

            ContractTypeForFundingTypeFundingPeriodRule rule = new ContractTypeForFundingTypeFundingPeriodRule(GetContractTypesForFundingInfo);

            // act
            IEnumerable<string> failures = rule.GetFailuresForItem(masterContract);

            // assert
            Assert.AreEqual(1, failures.Count(), "The number of failures is incorrect");
        }

        private contractRequestType GetContractRequestTypeFromFile()
        {
            return TestResource.FromJson<contractRequestType>("ContractCreateDomain.Tests",
                "Resources.contractRequestTypeContractTypeRule.json");
        }
    }
}
