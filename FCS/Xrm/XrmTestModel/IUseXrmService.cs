namespace XrmTestModel
{
    using Microsoft.Xrm.Sdk;

    public interface IUseXrmService
    {
        IXrmServiceFactory OrgServiceFactory { get; set; }

        IOrganizationService OrgService { get; set; }
    }

    public interface IXrmServiceFactory
    {
        IOrganizationService Create();

        IOrganizationService Create(string userName);
    }
}
