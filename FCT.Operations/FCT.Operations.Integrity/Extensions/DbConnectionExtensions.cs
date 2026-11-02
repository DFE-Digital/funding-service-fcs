namespace SFA.FCT.Operations.Integrity.Extensions
{
    using System.Data.Common;
    using CrossDomain.Integration.Entities.Data;

    public static class DbConnectionExtensions
    {
        public static ConnectionInfo ToConnectionInfo(this DbConnection connection)
        {
            return ConnectionInfo.CreateFrom(connection);
        }
    }
}
