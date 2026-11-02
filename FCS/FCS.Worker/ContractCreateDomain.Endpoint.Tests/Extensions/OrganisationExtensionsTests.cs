namespace ContractCreateDomain.Endpoint.Tests.Extensions
{
    using System.IO;
    using System.Reflection;
    using System.Xml.Linq;
    using System.Xml.Serialization;
    using Endpoint.Extensions;
    using FluentAssertions;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.CrossDomain.Integration.Entities;

    [TestClass]
    public class OrganisationExtensionsTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void OrganisationExtensions_ToContractOrganisation_ShouldReturnPopulatedObject()
        {
            // arrange
            var org = GetOrganisationFromFile("ContractCreateDomain.Endpoint.Tests", "Resources.organisation.xml");
            
            // act
            var contractOrganisation = org.ToContractOrganisation();

            // assert
            contractOrganisation.UKPRN.Should().Be("10020172");
            contractOrganisation.Upin.Should().Be("122759");
            contractOrganisation.Type.Should().Be("PRI/LBG/NSC (Use of Limited exemption)");
            contractOrganisation.CompanyNumber.Should().Be("AA122759");
            contractOrganisation.CharityNumber.Should().BeNull();
            contractOrganisation.Name.Should().Be("NACRO");
            contractOrganisation.OrganisationId.Should().Be("ORG0020172");
            contractOrganisation.Address.AddressLine1.Should().Be("15 Princeton Mews");
            contractOrganisation.Address.AddressLine2.Should().Be("167-169 London Road");
            contractOrganisation.Address.AddressLine3.Should().Be("Kingston upon Thames");
            contractOrganisation.Address.AddressLine4.Should().BeNull();
            contractOrganisation.Address.County.Should().Be("Surrey");
            contractOrganisation.Address.Postcode.Should().Be("KT2 6PT");
            contractOrganisation.Status.Should().Be("Active");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void OrganisationExtensions_ToContractOrganisation_ShouldReturnPopulatedObjectWhenTypeEmpty()
        {
            // arrange
            var org = GetOrganisationFromFile("ContractCreateDomain.Endpoint.Tests", "Resources.organisation_no_type.xml");

            // act
            var contractOrganisation = org.ToContractOrganisation();

            // assert
            contractOrganisation.UKPRN.Should().Be("10000527");
            contractOrganisation.Upin.Should().Be("100527");
            contractOrganisation.Type.Should().BeEmpty();
        }

        private organisation GetOrganisationFromFile(string nameSpace, string resourceName)
        {
            using (Stream stream = Assembly.GetCallingAssembly().GetManifestResourceStream($"{nameSpace}.{resourceName}"))
            using (StreamReader streamReader = new StreamReader(stream))
            {
                XDocument document = XDocument.Load(stream);

                XmlSerializer serializer = new XmlSerializer(typeof(organisation));
                return (organisation)serializer.Deserialize(document.Root.CreateReader());
            }
        }
    }
}
