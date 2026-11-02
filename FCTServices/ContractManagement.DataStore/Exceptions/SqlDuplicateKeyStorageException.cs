namespace ContractManagement.DataStore.Exceptions
{
    using System;

    public class SqlDuplicateKeyStorageException : Exception
    {
        public SqlDuplicateKeyStorageException(Exception innerException)
            : base("Duplicate Key", innerException)
        {
        }
    }
}
