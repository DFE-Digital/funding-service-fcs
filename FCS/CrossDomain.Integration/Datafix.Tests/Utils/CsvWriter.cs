namespace Datafix.Tests.Utils
{
    using System;
    using System.Collections.Generic;
    using System.IO;
    using System.Linq;
    using System.Reflection;
    internal class CsvWriter<T> where T : class
    {
        private readonly List<string> _fileLines = new List<string>();
        private PropertyInfo[] _typePropertyInfos = null;

        public string CreateCsv(IEnumerable<T> items)
        {
            CreateFileLines(items);

            StringWriter writer = new StringWriter();

            _fileLines.ForEach(writer.WriteLine);

            return writer.ToString();
        }

        public void SaveItems(IEnumerable<T> items, string fileName)
        {
            if (string.IsNullOrEmpty(fileName))
            {
                throw new ArgumentException("fileName cannot be null or empty");
            }

            CreateFileLines(items);

            CreateFile(fileName);
        }

        private void CreateFileLines(IEnumerable<T> items)
        {
            _fileLines.Add(GetHeaderFileLine());

            // now add the data lines
            _fileLines.AddRange(GetItemsInCsvFormat(items));
        }

        private IList<string> GetItemsInCsvFormat(IEnumerable<T> items)
        {
            return items.Select(i => string.Join(",", PropertyInfos.Select(pi => pi.GetValue(i)))).ToList();
        }

        private PropertyInfo[] PropertyInfos
        {
            get
            {
                if (_typePropertyInfos == null)
                {
                    _typePropertyInfos = typeof(T).GetProperties()
                        .Where(pi => !IsIgnoreColumnProperty(pi)).ToArray();

                    _typePropertyInfos = _typePropertyInfos.OrderBy(
                        pi => (GetOrderAttributeForProperty(pi)).Order).ToArray();
                }

                return _typePropertyInfos;
            }
        }

        private OrderAttribute GetOrderAttributeForProperty(PropertyInfo propertyInfo)
        {
            OrderAttribute order = propertyInfo.GetCustomAttribute<OrderAttribute>();

            return order ?? new OrderAttribute(1);
        }

        private bool IsIgnoreColumnProperty(PropertyInfo propertyInfo)
        {
            IgnoreColumnWhenGeneratingCsvAttribute ignoreColumn = propertyInfo.GetCustomAttribute<IgnoreColumnWhenGeneratingCsvAttribute>();

            return ignoreColumn != null;
        }

        private string GetHeaderFileLine()
        {
            return string.Join(",", PropertyInfos.Select(pi => pi.Name));
        }

        private void CreateFile(string fileName)
        {
            using (StreamWriter writer = new StreamWriter(fileName))
            {
                _fileLines.ForEach(writer.WriteLine);
            }
        }
    }
}
