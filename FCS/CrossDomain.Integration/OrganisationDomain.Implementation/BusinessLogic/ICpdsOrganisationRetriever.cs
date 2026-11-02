namespace OrganisationDomain.Implementation.BusinessLogic
{
    using System.Xml.Linq;

    public interface ICpdsOrganisationRetriever
    {
       XDocument GetProviderByUkprn(int ukprn);

        XDocument GetProviderByUkprnAndUpin(int ukprn, int upin);
    }
}
