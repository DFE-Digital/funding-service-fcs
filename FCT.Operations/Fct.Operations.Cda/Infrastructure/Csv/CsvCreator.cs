namespace FCT.Operations.Cda.Infrastructure.Csv
{
    using System.Collections.Generic;
    using System.Linq;
    using System.Reflection;
    using Attributes;

    public class CsvCreator<T>
    {
        private PropertyInfo[] _typePropertyInfos = null;

        public List<string> CreateFileLines(IEnumerable<T> items)
        {
            List<string> lines = new List<string> {GetHeaderFileLine()};

            // now add the data lines
            lines.AddRange(GetItemsInCsvFormat(items));

            return lines;
        }

        private string GetHeaderFileLine()
        {
            return string.Join(",", PropertyInfos.Select(pi => pi.Name));
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

        private bool IsIgnoreColumnProperty(PropertyInfo propertyInfo)
        {
            IgnoreColumnWhenGeneratingCsvAttribute ignoreColumn = propertyInfo.GetCustomAttribute<IgnoreColumnWhenGeneratingCsvAttribute>();

            return ignoreColumn != null;
        }

        private OrderAttribute GetOrderAttributeForProperty(PropertyInfo propertyInfo)
        {
            OrderAttribute order = propertyInfo.GetCustomAttribute<OrderAttribute>();

            return order ?? new OrderAttribute(1);
        }
    }
}
