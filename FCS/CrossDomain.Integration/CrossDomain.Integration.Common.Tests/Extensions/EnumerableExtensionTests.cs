namespace CrossDomain.Integration.Common.Tests.Extensions
{
    using System.Collections.Generic;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.CrossDomain.Integration.Common.Extensions;

    [TestClass]
    public class EnumerableExtensionTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void EnumerableExtensions_ShouldReturnFalse_WhenNoneCalledWithItemsThatDontMatchPredicate()
        {
            // arrange
            IList<Customer> customers = new List<Customer>
            {
                new Customer(isPremium: true),
                new Customer(isPremium: false)
            };

            // act and assert
            Assert.IsFalse(customers.None(c => c.IsPremium));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void EnumerableExtensions_ShouldReturnTrue_WhenNoneCalledWithItemsThatAllFailPredicate()
        {
            // arrange
            IList<Customer> customers = new List<Customer>
            {
                new Customer(isPremium: false),
                new Customer(isPremium: false)
            };

            // act and assert
            Assert.IsTrue(customers.None(c => c.IsPremium));
        }

        private class Customer
        {
            public Customer(bool isPremium)
            {
                IsPremium = isPremium;
            }

            public bool IsPremium { get; }
        }
    }
}
