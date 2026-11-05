namespace ContractCreateDomain.Implementation.Tests.Unit
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using Microsoft.Xrm.Sdk;
    using Microsoft.Xrm.Sdk.Client;
    using Microsoft.Xrm.Sdk.Messages;
    using Microsoft.Xrm.Sdk.Query;
    using Moq;

    /// <summary>
    /// Fakes an <see cref="IOrganizationService"/> for the Xrm LINQ provider, which issues RetrieveMultipleRequests
    /// and reads joined columns back as aliased values.
    /// </summary>
    internal sealed class FakeXrmService
    {
        private readonly Func<QueryExpression, IEnumerable<Entity>> _handler;

        public FakeXrmService(Func<QueryExpression, IEnumerable<Entity>> handler)
        {
            _handler = handler;
            Mock = new Mock<IOrganizationService>();
            Mock.Setup(s => s.Execute(It.IsAny<OrganizationRequest>()))
                .Returns<OrganizationRequest>(request =>
                {
                    var retrieveMultiple = (RetrieveMultipleRequest)request;
                    var query = (QueryExpression)retrieveMultiple.Query;
                    Queries.Add(query);
                    var collection = new EntityCollection(_handler(query).ToList()) { EntityName = query.EntityName };
                    return new RetrieveMultipleResponse
                    {
                        Results = new ParameterCollection { { "EntityCollection", collection } }
                    };
                });
        }

        public Mock<IOrganizationService> Mock { get; }

        public List<QueryExpression> Queries { get; } = new List<QueryExpression>();

        public IOrganizationService Service => Mock.Object;

        /// <summary>
        /// Builds an entity for the query's primary entity carrying aliased values for each joined column.
        /// </summary>
        public static Entity Row(QueryExpression query, Func<string, string, object> valueFor, params string[] candidateColumns)
        {
            return Row(query, valueFor, entityName => candidateColumns);
        }

        /// <summary>
        /// As above, but resolves the columns to supply for "all columns" requests per entity logical name.
        /// </summary>
        public static Entity Row(QueryExpression query, Func<string, string, object> valueFor, Func<string, string[]> candidateColumnsFor)
        {
            var entity = CreateTypedEntity(query.EntityName);
            entity.Id = Guid.NewGuid();

            foreach (var column in query.ColumnSet.AllColumns ? candidateColumnsFor(query.EntityName) : query.ColumnSet.Columns.ToArray())
            {
                var value = valueFor(query.EntityName, column);
                if (value != null)
                {
                    entity[column] = value;
                }
            }

            AddLinks(entity, query.LinkEntities, valueFor, candidateColumnsFor);
            return entity;
        }

        internal static Type FindEntityType(string logicalName)
        {
            return typeof(SFA.FCT.CrossDomain.Integration.Entities.Xrm.XrmServiceContext).Assembly
                .GetTypes()
                .FirstOrDefault(t => typeof(Entity).IsAssignableFrom(t)
                    && t.GetCustomAttributes(typeof(EntityLogicalNameAttribute), false)
                        .Cast<EntityLogicalNameAttribute>()
                        .Any(a => a.LogicalName == logicalName));
        }

        private static Entity CreateTypedEntity(string logicalName)
        {
            var entityType = typeof(SFA.FCT.CrossDomain.Integration.Entities.Xrm.XrmServiceContext).Assembly
                .GetTypes()
                .FirstOrDefault(t => typeof(Entity).IsAssignableFrom(t)
                    && t.GetCustomAttributes(typeof(EntityLogicalNameAttribute), false)
                        .Cast<EntityLogicalNameAttribute>()
                        .Any(a => a.LogicalName == logicalName));

            return entityType == null ? new Entity(logicalName) : (Entity)Activator.CreateInstance(entityType);
        }

        private static void AddLinks(Entity entity, IEnumerable<LinkEntity> links, Func<string, string, object> valueFor, Func<string, string[]> candidateColumnsFor)
        {
            foreach (var link in links)
            {
                foreach (var column in link.Columns.AllColumns ? candidateColumnsFor(link.LinkToEntityName) : link.Columns.Columns.ToArray())
                {
                    var value = valueFor(link.LinkToEntityName, column);
                    if (value != null)
                    {
                        entity[link.EntityAlias + "." + column] =
                            new AliasedValue(link.LinkToEntityName, column, value);
                    }
                }

                AddLinks(entity, link.LinkEntities, valueFor, candidateColumnsFor);
            }
        }
    }
}
