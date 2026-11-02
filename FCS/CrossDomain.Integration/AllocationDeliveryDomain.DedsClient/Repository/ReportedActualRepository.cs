namespace AllocationDeliveryDomain.DedsClient.Repository
{
    using System;
    using System.Collections.Generic;
    using System.IO;
    using System.Reflection;
    using Dtos;

    public class ReportedActualRepository
    {
        public static void SaveReportedActuals(IEnumerable<ReportedActual> reportedActuals)
        {
            using (StreamWriter w = File.AppendText("ReportedActual.txt"))
            {
                Write(reportedActuals, w);
            }
        }

        private static void Write(IEnumerable<ReportedActual> reportedActuals, TextWriter w)
        {

            foreach (var reportedActual in reportedActuals)
            {
                Dictionary<string, string> record = GetPropertyNameAndValue(reportedActual);

                foreach (var field in record)
                {
                    w.WriteLine(field.Key + " : " + field.Value);
                }

                w.WriteLine("========================================================");
            }
        }

        private static Dictionary<string, string> GetPropertyNameAndValue(ReportedActual data)
        {
            Dictionary<string, string> reportedActualDictionary = new Dictionary<string, string>();
            Type t = data.GetType();
            foreach (PropertyInfo pi in t.GetProperties())
            {
                reportedActualDictionary[pi.Name] = pi.GetValue(data, null).ToString();

            }
            return reportedActualDictionary;
        }
    }
}
