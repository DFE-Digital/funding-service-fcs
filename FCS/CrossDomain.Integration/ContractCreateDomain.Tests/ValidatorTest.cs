namespace ContractCreateDomain.Tests
{
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using SFA.FCT.ContractCreateDomain.BusinessLogic.Validation;
    using SFA.FCT.CrossDomain.Integration.Entities.ContractRequest;
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using SFA.FCT.ContractCreateDomain.BusinessLogic.Validation.Rules;

    [TestClass]
    public class ValidatorTest
    {
        [TestMethod, TestCategory("UnitTest"), ExpectedException(typeof(InvalidOperationException))]
        public void Validate_WhenContractRequestContainsISAChildContract_RaiseException()
        {
            // Arrange            
            var testContractRequest = CreateEmptyContractRequest();
            testContractRequest.contract.contracts.AddRange(
                new List<contractType>
                {
                    new contractType
                    {
                        contractNumber = "contract1",
                        hierarchyType = hierarchyType.CONTRACT
                    },
                }
            );
            testContractRequest.contract.hierarchyType = hierarchyType.CONTRACT;

            var mockedRule = new Mock<IRule<contractRequestType>>();
            var mockedRuleset = new List<IRule<contractRequestType>>
            {
                mockedRule.Object
            };

            var validatorUnderTest = new Validator();

            // Act
            validatorUnderTest.Validate(testContractRequest, mockedRuleset);

            // Assert
        }

        [TestMethod, TestCategory("UnitTest"), ExpectedException(typeof(InvalidOperationException))]
        public void Validate_WhenContractRequestContainsNoMasterContracts_RaiseException()
        {
            // Arrange            
            var testContractRequest = new contractRequestType();
            testContractRequest.contract = null;

            var mockedRule = new Mock<IRule<contractRequestType>>();
            var mockedRuleset = new List<IRule<contractRequestType>>
            {
                mockedRule.Object
            };

            var validatorUnderTest = new Validator();

            // Act
            validatorUnderTest.Validate(testContractRequest, mockedRuleset);

            // Assert
        }

        [TestMethod, TestCategory("UnitTest"), ExpectedException(typeof(InvalidOperationException))]
        public void Validate_WhenContractRequestContainsNoChildContracts_RaiseException()
        {
            // Arrange            
            var testContractRequest = CreateEmptyContractRequest();
            var mockedRule = new Mock<IRule<contractRequestType>>();
            var mockedRuleset = new List<IRule<contractRequestType>>
            {
                mockedRule.Object
            };

            var validatorUnderTest = new Validator();

            // Act
            validatorUnderTest.Validate(testContractRequest, mockedRuleset);

            // Assert
        }        

        [TestMethod, TestCategory("UnitTest")]
        public void Validator_Validate_ShouldNotRaiseExceptionWhenContractRequestContainsMultipleChildContracts()
        {
            // Arrange            
            var testContractRequest = CreateEmptyContractRequest();
            testContractRequest.contract.contracts.AddRange(
                new List<contractType>
                {
                    new contractType
                    {
                        contractNumber = "contract1",
                        hierarchyType = hierarchyType.CONTRACT
                    },
                    new contractType
                    {
                        contractNumber = "contract2",
                        hierarchyType = hierarchyType.CONTRACT
                    }
                }               
            );

            var mockedRule = new Mock<IRule<contractRequestType>>();
            var mockedRuleset = new List<IRule<contractRequestType>>
            {
                mockedRule.Object
            };

            var validatorUnderTest = new Validator();

            // Act
            var result = validatorUnderTest.Validate(testContractRequest, mockedRuleset);

            // Assert
            Assert.IsTrue(result);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Validate_WhenContractRequestContainsExactlyOneChildContracts_RulesAreCalled()
        {
            // Arrange            
            var testContractRequest = CreateEmptyContractRequest();
            testContractRequest.contract.contracts.AddRange(
                new List<contractType>
                {
                    new contractType
                    {
                        contractNumber = "contract1",
                        hierarchyType = hierarchyType.CONTRACT
                    },                   
                }
            );

            var mockedRule = new Mock<IRule<contractRequestType>>();
            mockedRule.Setup(m => m.GetFailuresForItem(It.IsAny<contractRequestType>())).Returns(new List<string>());
            var mockedRuleset = new List<IRule<contractRequestType>>
            {
                mockedRule.Object
            };

            var validatorUnderTest = new Validator();

            // Act
            validatorUnderTest.Validate(testContractRequest, mockedRuleset);

            // Assert
            mockedRule.VerifyAll();
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Validate_WhenContractRequestContainsExactlyOneChildContracts_ValidationReturnsTrueWhenRulePasses()
        {
            // Arrange            
            var testContractRequest = CreateEmptyContractRequest();
            testContractRequest.contract.contracts.AddRange(
                new List<contractType>
                {
                    new contractType
                    {
                        contractNumber = "contract1",
                        hierarchyType = hierarchyType.CONTRACT
                    },
                }
            );

            var mockedRule = new Mock<IRule<contractRequestType>>();
            mockedRule.Setup(m => m.GetFailuresForItem(It.IsAny<contractRequestType>()))
                .Returns(new List<string>());

            var mockedRuleset = new List<IRule<contractRequestType>>
            {
                mockedRule.Object
            };

            var validatorUnderTest = new Validator();

            // Act
            var result = validatorUnderTest.Validate(testContractRequest, mockedRuleset);

            // Assert
            Assert.IsTrue(result);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Validate_WhenContractRequestContainsExactlyOneChildContracts_ValidationReturnsFalseWhenRuleFails()
        {
            // Arrange            
            var testContractRequest = CreateEmptyContractRequest();
            testContractRequest.contract.contracts.AddRange(
                new List<contractType>
                {
                    new contractType
                    {
                        contractNumber = "contract1",
                        hierarchyType = hierarchyType.CONTRACT
                    },
                }
            );

            var mockedRule = new Mock<IRule<contractRequestType>>();
            mockedRule.Setup(m => m.GetFailuresForItem(It.IsAny<contractRequestType>()))
                .Returns(new List<string> { "Error1", "Error2" });

            var mockedRuleset = new List<IRule<contractRequestType>>
            {
                mockedRule.Object
            };

            var validatorUnderTest = new Validator();

            // Act
            var result = validatorUnderTest.Validate(testContractRequest, mockedRuleset);

            // Assert
            Assert.IsFalse(result);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Validator_ShouldAddSevereErrorInfoTypeWhenSevereRuleIsPresent()
        {
            // Arrange            
            var testContractRequest = CreateEmptyContractRequest();
            testContractRequest.contract.contracts.AddRange(
                new List<contractType>
                {
                    new contractType
                    {
                        contractNumber = "contract1",
                        hierarchyType = hierarchyType.CONTRACT
                    },
                }
            );

            var mockedRule = new Mock<IRule<contractRequestType>>();
            mockedRule.Setup(m => m.GetFailuresForItem(It.IsAny<contractRequestType>()))
                .Returns(new List<string> { "Error1", "Error2" });

            var mockedRuleset = new List<IRule<contractRequestType>>
            {
                mockedRule.Object,
                new InvalidUkprnRule()
            };

            var validatorUnderTest = new Validator();

            // Act
            validatorUnderTest.Validate(testContractRequest, mockedRuleset);

            // Assert
            Assert.AreEqual(1, testContractRequest.errorInfo.Count(e => e.Severity == ErrorSeverity.Severe));
        }

        private static contractRequestType CreateEmptyContractRequest()
        {
            var cr = new contractRequestType();
            cr.contract = new contractType
            {
                contractNumber = "mastercontract",
                hierarchyType = hierarchyType.MASTERCONTRACT
            };
            cr.contract.contracts = new List<contractType>();
            return cr;
        }
    }
}
