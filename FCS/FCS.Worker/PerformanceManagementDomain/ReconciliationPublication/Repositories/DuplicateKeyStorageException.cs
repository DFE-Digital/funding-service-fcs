namespace PerformanceManagementDomain.ReconciliationPublication.Repositories
{
    using System;

    public class DuplicateKeyStorageException : Exception
    {
        public DuplicateKeyStorageException(Exception innerException)
            : base("Duplicate Key", innerException)
        {
        }
    }
}
