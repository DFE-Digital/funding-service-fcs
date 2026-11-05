namespace ContractCreateDomain.Implementation.Tests.Unit
{
    using System;
    using System.Collections.Concurrent;
    using System.Collections.Generic;
    using System.Linq;
    using System.Reflection;
    using Microsoft.Crm.Sdk.Messages;
    using Microsoft.Xrm.Sdk;
    using Microsoft.Xrm.Sdk.Query;
    using Moq;

    /// <summary>
    /// A fake CRM that answers every query with a configurable number of rows. Column values come from an optional
    /// override function and otherwise default to a value matching the early-bound property type, so the join-heavy
    /// LINQ queries in ContractsManager can be run without a real organisation service.
    /// </summary>
    internal sealed class FakeCrm
    {
        /// <summary>Return this from an override to leave the column out of the row.</summary>
        public static readonly object Omit = new object();

        private static readonly ConcurrentDictionary<string, Dictionary<string, Type>> ColumnTypes =
            new ConcurrentDictionary<string, Dictionary<string, Type>>();

        private readonly Func<string, string, object> _overrides;
        private readonly Func<QueryExpression, int> _rowCount;

        // Recursive deliverable queries would never terminate if every query returned a row.
        private static Func<QueryExpression, int> SingleLevelDeliverables()
        {
            var deliverableQueries = 0;
            return query => query.EntityName == "sfa_contractdeliverable" && !query.LinkEntities.Any() && deliverableQueries++ > 0 ? 0 : 1;
        }

        public FakeCrm(Func<string, string, object> overrides = null, Func<QueryExpression, int> rowCount = null)
        {
            _overrides = overrides;
            _rowCount = rowCount ?? SingleLevelDeliverables();
            Xrm = new FakeXrmService(Handle);

            Xrm.Mock
                .Setup(s => s.Execute(It.Is<OrganizationRequest>(r => r is LocalTimeFromUtcTimeRequest)))
                .Returns<OrganizationRequest>(r => new LocalTimeFromUtcTimeResponse
                {
                    Results = new ParameterCollection
                    {
                        { "LocalTime", ((LocalTimeFromUtcTimeRequest)r).UtcTime.AddHours(LocalOffsetHours) }
                    }
                });

            Xrm.Mock
                .Setup(s => s.RetrieveMultiple(It.Is<QueryBase>(q => ((QueryExpression)q).EntityName == "usersettings")))
                .Returns(() =>
                {
                    var settings = new Entity("usersettings");
                    if (TimeZoneCode.HasValue)
                    {
                        settings["timezonecode"] = TimeZoneCode.Value;
                    }
                    else
                    {
                        settings["timezonecode"] = null;
                    }

                    return new EntityCollection(new List<Entity> { settings });
                });
        }

        public FakeXrmService Xrm { get; }

        public IOrganizationService Service => Xrm.Service;

        public int LocalOffsetHours { get; set; } = 1;

        public int? TimeZoneCode { get; set; } = 85;

        public IEnumerable<string> QueriedEntities => Xrm.Queries.Select(q => q.EntityName);

        public System.Collections.Generic.List<Entity> Rows { get; } = new System.Collections.Generic.List<Entity>();

        private IEnumerable<Entity> Handle(QueryExpression query)
        {
            var count = _rowCount?.Invoke(query) ?? 1;
            var rows = Enumerable.Range(0, count)
                .Select(i => FakeXrmService.Row(query, ValueFor, CandidateColumns))
                .ToList();
            Rows.AddRange(rows);
            return rows;
        }

        private object ValueFor(string entityName, string column)
        {
            var overridden = _overrides?.Invoke(entityName, column);
            if (ReferenceEquals(overridden, Omit))
            {
                return null;
            }

            return overridden ?? DefaultValue(entityName, column);
        }

        private static string[] CandidateColumns(string entityName)
        {
            return GetColumnTypes(entityName).Keys.ToArray();
        }

        private static Dictionary<string, Type> GetColumnTypes(string entityName)
        {
            return ColumnTypes.GetOrAdd(entityName, name =>
            {
                var result = new Dictionary<string, Type>();
                var type = FakeXrmService.FindEntityType(name);
                if (type != null)
                {
                    foreach (var property in type.GetProperties(BindingFlags.Public | BindingFlags.Instance | BindingFlags.DeclaredOnly))
                    {
                        var attribute = property.GetCustomAttribute<AttributeLogicalNameAttribute>();
                        if (attribute != null && property.GetCustomAttribute<RelationshipSchemaNameAttribute>() == null)
                        {
                            result[attribute.LogicalName] = property.PropertyType;
                        }
                    }
                }

                return result;
            });
        }

        private static object DefaultValue(string entityName, string column)
        {
            Type propertyType;
            if (!GetColumnTypes(entityName).TryGetValue(column, out propertyType))
            {
                return null;
            }

            var type = Nullable.GetUnderlyingType(propertyType) ?? propertyType;

            if (type == typeof(string))
            {
                return "1";
            }

            if (type == typeof(int))
            {
                return 1;
            }

            if (type == typeof(decimal))
            {
                return 1m;
            }

            if (type == typeof(double))
            {
                return 1d;
            }

            if (type == typeof(bool))
            {
                return false;
            }

            if (type == typeof(DateTime))
            {
                return new DateTime(2019, 1, 1, 0, 0, 0, DateTimeKind.Utc);
            }

            if (type == typeof(Guid))
            {
                return Guid.NewGuid();
            }

            if (type == typeof(Money))
            {
                return new Money(1m);
            }

            if (type == typeof(EntityReference))
            {
                return new EntityReference(column == "ownerid" ? "systemuser" : "account", Guid.NewGuid()) { Name = "Name" };
            }

            // Option sets stay null unless a test supplies a value, because many of them are validated against an enum.
            return null;
        }
    }
}
