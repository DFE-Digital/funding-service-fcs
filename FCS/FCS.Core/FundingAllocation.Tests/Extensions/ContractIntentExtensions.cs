namespace FundingAllocation.Tests.Extensions
{
    using System.Collections.Generic;
    using FluentAssertions;
    using FundingAllocation.Extensions;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.CrossDomain.Integration.Entities.CorporateContract;

    [TestClass]
    public class ContractIntentExtensions
    {
        [TestMethod, TestCategory("UnitTest")]
        public void ContractIntent_DoesNotRequiresExistingContractInfo_ShouldReturnFalseWhenIntentDoesNotRequireExistingContractInfo()
        {
            // arrange
            var inputAndExpectedTuples = new List<(ContractIntent intent, bool doesNotRequireExistingContractInfo)>
            {
                (ContractIntent.UpdateDraft, false),
                (ContractIntent.UpdateDraftAmendment, false),
                (ContractIntent.New, true),
                (ContractIntent.Queue, false),
                (ContractIntent.RevisedNew, false),
            };

            inputAndExpectedTuples.ForEach(i =>
            {
                // act
                var result = i.intent.DoesNotRequiresExistingContractInfo();
                // assert
                result.Should().Be(i.doesNotRequireExistingContractInfo, $"The intent of {i.intent}, has failed");
            });
        }
    }
}
