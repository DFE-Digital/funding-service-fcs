namespace OrganisationDomain.Integration.DataStore.Tests.Model
{
    using DataStore.Model;
    using Microsoft.VisualStudio.TestTools.UnitTesting;

    [TestClass]
    public class AddressTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void OrganisationAddress_HasValue_ShouldReturnTrueWhenAnyPropertiesHaveValues()
        {
            Assert.IsTrue(new Address { Line1 = "x" }.HasValue);
            Assert.IsTrue(new Address { Line2 = "x" }.HasValue);
            Assert.IsTrue(new Address { Line3 = "x" }.HasValue);
            Assert.IsTrue(new Address { Line4 = "x" }.HasValue);
            Assert.IsTrue(new Address { Town = "x" }.HasValue);
            Assert.IsTrue(new Address { County = "x" }.HasValue);
            Assert.IsTrue(new Address { Postcode = "x" }.HasValue);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void OrganisationAddress_HasValue_ShouldReturnFalseWhenNoPropertiesHaveValues()
        {
            Assert.IsFalse(new Address().HasValue);
        }
    }
}
