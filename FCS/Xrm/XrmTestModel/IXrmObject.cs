namespace XrmTestModel
{
    using System;
    using Microsoft.Xrm.Sdk;

    public interface IUseXrmObject<T>
    {
        IOrganizationService OrgService { get; set; }
        IUseXrmObject<T> Get();
        IUseXrmObject<T> Get(string primaryFieldName);
        IUseXrmObject<T> Get(Func<T, bool> predicate);
        Guid GetId();
        EntityReference GetEntityReference();
        void Save();
        void TranslateFromXrm(T xrmEntity);
        void TranslateToXrm();
    }
}