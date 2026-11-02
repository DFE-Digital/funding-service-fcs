namespace SFA.FCT.CrossDomain.Integration.OverrideDate.DataStore.Services
{
    using System;
    using Entities.Data;

    public interface IDateProvider
    {
        DateTime GetDate(ConnectionInfo connectionInfo);
    }
}
