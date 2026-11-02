namespace SFA.FCT.AllocationDeliveryDomain.Common.DataStore.Migrations.Helpers
{
    using System.ComponentModel;
    using System.Data;
    using System.Data.SqlClient;
    using System.IO;
    using System.Reflection;

    public static class SqlBulkCopyHelper
    {
        public static long WriteToTableFromCsv<T>(string connectionString, string tableName, Stream stream)
        {
            using (SqlBulkCopy bulkCopy = new SqlBulkCopy(connectionString))
            {
                foreach (PropertyDescriptor property in TypeDescriptor.GetProperties(typeof(T)))
                {
                    bulkCopy.ColumnMappings.Add(property.Name, property.Name);
                }

                bulkCopy.BatchSize = 1000;
                bulkCopy.DestinationTableName = tableName;
                bulkCopy.WriteToServer(DataTableFromCsvStream(stream));

                // have to get the final rowsCopied figure by reflection
                FieldInfo rowsCopiedField = typeof(SqlBulkCopy).GetField(
                    "_rowsCopied", BindingFlags.NonPublic | BindingFlags.GetField | BindingFlags.Instance);
                return (int)rowsCopiedField.GetValue(bulkCopy);
            }
        }

        private static DataTable DataTableFromCsvStream(Stream csvStream)
        {
            using (StreamReader sr = new StreamReader(csvStream))
            {
                DataTable dataTable = new DataTable();
                string[] headers = sr.ReadLine().Split(',');

                foreach (string header in headers)
                {
                    dataTable.Columns.Add(header);
                }

                while (!sr.EndOfStream)
                {
                    string[] rows = sr.ReadLine().Split(',');

                    DataRow dr = dataTable.NewRow();

                    for (int i = 0; i < headers.Length; i++)
                    {
                        dr[i] = rows[i];
                    }

                    dataTable.Rows.Add(dr);
                }

                return dataTable;
            }
        }
    }
}
