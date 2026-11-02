namespace FCT.Console.Config.Extraction.PaaS
{
    using System;
    using System.Configuration;
    using System.Data;
    using System.Data.SqlClient;
    using System.Linq;
    using System.Text;
    using MoreLinq;

    public static class SqlTableExtractor
    {
        public static string ExtractDataAsCsv(string tableName)
        {
            DataTable dataTable = GetDataTable(tableName);

            return TransformDataTableToCsv(dataTable);
        }

        private static DataTable GetDataTable(string tableName)
        {
            string connectionString = ConfigurationManager.ConnectionStrings["ContractManagementDbContext"].ConnectionString;
            DataTable dataTable = new DataTable();

            using (SqlConnection sqlConnection = new SqlConnection(connectionString))
            {
                sqlConnection.Open();

                using (SqlCommand sqlCommand = new SqlCommand($"SELECT * FROM {tableName}", sqlConnection))
                using (SqlDataAdapter sqlDataAdapter = new SqlDataAdapter(sqlCommand))
                {
                    sqlDataAdapter.Fill(dataTable);
                }

                sqlConnection.Close();
            }

            return dataTable;
        }

        private static string TransformDataTableToCsv(DataTable dataTable)
        {
            StringBuilder stringBuilder = new StringBuilder();

            string csvHeading = string.Join(",", dataTable.Columns.Cast<DataColumn>().Select(dc => dc.ColumnName));
            stringBuilder.AppendLine(csvHeading);

            dataTable.Rows.Cast<DataRow>().ForEach(dr =>
            {
                string csvDataRow = string.Join(",", dr.ItemArray.Select(o =>
                {
                    if (o is DateTime dt)
                    {
                        return dt.ToString("yyyy-MM-dd HH:mm:ss");
                    }

                    return QuoteValueAsNecessary(o.ToString());
                }));
                stringBuilder.AppendLine(csvDataRow);
            });

            return stringBuilder.ToString();
        }

        private static string QuoteValueAsNecessary(string value)
        {
            return value.Contains(",") ? $"\"{value}\"" : value;
        }
    }
}
