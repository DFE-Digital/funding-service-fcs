namespace Datafix.Tests.Infrastructure
{
    using System;
    using System.Collections.Generic;
    using System.Data.SqlClient;
    using Dapper;
    using Polly;

    public class SqlConnectionWithRetry : IDisposable
    {
        private const int numberOfRetries = 10;
        private const int increasingBackoffSecondsBetweenRetries = 1;
        private readonly string _connectionString;

        public SqlConnectionWithRetry(string connectionString)
        {
            _connectionString = connectionString;
        }

        public void Dispose()
        {
        }

        public IEnumerable<T> Query<T>(string sql, object param = null, int? commandTimeout = null)
        {
            return ExecuteWithRetry(() =>
            {
                using (SqlConnection connection = new SqlConnection(_connectionString))
                {
                    return connection.Query<T>(sql, param, commandTimeout: commandTimeout);
                }
            });
        }

        public T ExecuteScalar<T>(string sql)
        {
            return ExecuteWithRetry(() =>
            {
                using (SqlConnection connection = new SqlConnection(_connectionString))
                {
                    return connection.ExecuteScalar<T>(sql);
                }
            });
        }

        public int Execute(string sql, int? commandTimeout = null, object param = null)
        {
            var executeResult = ExecuteWithRetry(() =>
            {
                using (SqlConnection connection = new SqlConnection(_connectionString))
                {
                    return connection.Execute(sql, commandTimeout: commandTimeout, param: param);
                }
            });

            return executeResult;
        }

        private static T ExecuteWithRetry<T>(Func<T> fn)
        {
            return
                Policy.Handle<Exception>(ex => true)
                    .WaitAndRetry(numberOfRetries, count => TimeSpan.FromSeconds(count * increasingBackoffSecondsBetweenRetries))
                    .Execute(fn);
        }
    }
}
