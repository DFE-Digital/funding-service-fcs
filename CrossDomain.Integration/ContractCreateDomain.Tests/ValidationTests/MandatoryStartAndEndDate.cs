using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using SFA.FCT.CrossDomain.Integration.Entities.ContractRequest;

namespace ContractCreateDomain.Tests.ValidationTests
{
    using SFA.FCT.ContractCreateDomain.BusinessLogic.Validation.Rules;

    [TestClass]
    public class MandatoryStartAndEndDate : ContractRequestValidationBase
    {
        private StartAndEndDatesMandatoryRule _validator;

        [TestInitialize]
        public void Startup()
        {
            _validator = new StartAndEndDatesMandatoryRule();
        }

        [TestMethod, TestCategory("UnitTest")]
        public void EnsureNullAllocationDatesArePopulatedWithContractDates()
        {
            var contracts = Contract.contract.contracts.First();

            Contract.contract.contracts = new List<contractType> {contracts};
            Contract.contract.fundingTypeCode = "MAIN";
            Contract.contract.contracts.First().contractAllocations.First().startDate = null;
            Contract.contract.contracts.First().contractAllocations.First().endDate = null;

            Assert.IsFalse(_validator.GetFailuresForItem(Contract).Any());

            // Allocation Start and End dates must match the contracts start and end dates. 
            Assert.IsTrue(Contract.contract.contracts.First().contractAllocations.First().startDate == Contract.contract.contracts.First().startDate &&
           Contract.contract.contracts.First().contractAllocations.First().endDate == Contract.contract.contracts.First().endDate);
            
        }

        [TestMethod, TestCategory("UnitTest")]
        public void EnsureNullAllocationDatesAreNoPopulatedWithContractDates()
        {
            var contracts = Contract.contract.contracts.First();

            Contract.contract.contracts = new List<contractType> { contracts };
            Contract.contract.fundingTypeCode = "ESF";
            Contract.contract.contracts.First().contractAllocations.First().startDate = null;
            Contract.contract.contracts.First().contractAllocations.First().endDate = null;

            Assert.IsTrue(_validator.GetFailuresForItem(Contract).Any());

            // Allocation Start and End dates must match the contracts start and end dates. 
            Assert.IsFalse(Contract.contract.contracts.First().contractAllocations.First().startDate == Contract.contract.contracts.First().startDate &&
           Contract.contract.contracts.First().contractAllocations.First().endDate == Contract.contract.contracts.First().endDate);

        }

    }
}
