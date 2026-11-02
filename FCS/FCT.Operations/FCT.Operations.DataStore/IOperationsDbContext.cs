namespace SFA.FCT.Operations.DataStore
{
    using System;
    using System.Data.Entity;
    using Model;

    public interface IOperationsDbContext : IDisposable
    {
        IDbSet<ErrorMessageAction> ErrorMessageActions { get; set; }

        int SaveChanges();
    }
}

