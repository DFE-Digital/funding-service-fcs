namespace SFA.FCT.CrossDomain.Integration.OverrideDate.DataStore
{
    using System;
    using System.Data.Entity;

    public interface IOverrideDateDBContext : IDisposable
    {
        IDbSet<DataStore.Model.OverrideDate> OverrideDate { get; set; }

        int SaveChanges();
    }
}