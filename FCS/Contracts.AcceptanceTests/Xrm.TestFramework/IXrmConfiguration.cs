// <copyright file="IXrmConfiguration.cs" company="Ciber">
//     Company Copyright
// </copyright>
namespace Ciber.Xrm.Tests.MetaData
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Text;
    using System.Threading.Tasks;

    /// -----------------------------------------------------------------
    ///   Namespace:      Ciber.Xrm.Tests.MetaData
    ///   Interface:      IXrmConfiguration
    ///   Description:    Interface to be implemented by classes owning the Dynamics CRM metadata
    ///   Notes:          
    ///   Author:         Ben Bartle    
    /// -----------------------------------------------------------------
    /// <summary> 
    /// To be implemented by XrmConfiguration and XrmPackageConfiguration
    /// </summary> 
    public interface IXrmConfiguration
    {
        #region Methods
        /// <summary>
        /// Method to return the IXrmEntity Object corresponding to the entity logical name.
        /// </summary>
        /// <param name="entityName">The Logical name of the entity</param>
        /// <returns>The IXrmEntity Object corresponding to the entity logical name</returns>
        IXrmEntity Entity(string entityName);

        #endregion  
    }

    /// -----------------------------------------------------------------
    ///   Namespace:      Ciber.Xrm.Tests.MetaData
    ///   Interface:      IXrmEntity
    ///   Description:    Interface to be implemented by classes owning the Dynamics CRM entity metadata
    ///   Notes:          
    ///   Author:         Ben Bartle    
    /// -----------------------------------------------------------------
    /// <summary> 
    /// To be implemented by XrmEntity and XrmPackageEntity
    /// </summary> 
    public interface IXrmEntity
    {
        #region Properties
        /// <summary>
        /// Gets the Logical Name of the Entity
        /// </summary>
        string LogicalName { get; }

        #endregion

        #region Methods

       
        IXrmEntity HasDisplayName(string displayNameString);

        /// <summary>
        /// Gets the Object Type Code of the Entity
        /// </summary>
        IXrmEntity HasObjectTypeCode(int objectTypeCode);

        /// <summary>
        /// Gets a value indicating whether the entity is an Activity Type
        /// </summary>
        IXrmEntity IsActivity();

        /// <summary>
        /// Gets a value indicating whether the entity is Audit Enabled
        /// </summary>
        IXrmEntity IsAuditEnabled();

        /// <summary>
        /// Method to return a specific IXrmAttribute form the attribute logical name. 
        /// </summary>
        /// <param name="attributeName">The logical name of the Dynamics CRM Attribute</param>
        /// <returns>The IXrmAttribute object corresponding to the attribute logical name</returns>
        IXrmAttribute Attribute(string attributeName);

        /// <summary>
        /// Method to return a specific XrmPackageView form the view logical name. 
        /// </summary>
        /// <param name="attributeName">The name of the Dynamics CRM View</param>
        /// <returns>The XrmPackageView object corresponding to the view</returns>
        XrmPackageView View(string viewName);

        /// <summary>
        /// Method to return a specific XrmPackageView form the quick view. 
        /// </summary>
        /// <returns>The XrmPackageView object corresponding to the view</returns>
        XrmPackageView QuickView();

        #endregion 
    }

    /// -----------------------------------------------------------------
    ///   Namespace:      Ciber.Xrm.Tests.MetaData
    ///   Interface:      IXrmAttribute
    ///   Description:    Interface to be implemented by classes owning the Dynamics CRM attribute metadata
    ///   Notes:          
    ///   Author:         Ben Bartle    
    /// -----------------------------------------------------------------
    /// <summary> 
    /// To be implemented by XrmAttribute and XrmPackageAttribute
    /// </summary> 
    public interface IXrmAttribute
    {

        #region Properties
        string LogicalName { get; }

        #endregion

        #region Methods

        IXrmAttribute WithOption(int value, string label);

        IXrmAttribute HasType(string dataType);

        IXrmAttribute OfLength(int maxLength);

        IXrmAttribute WithMaxValue(int maxValue);

        IXrmAttribute WithMinValue(int minValue);

        IXrmAttribute HasDisplayName(string displayName);

        IXrmAttribute IsValidForAdvancedFind();

        IXrmAttribute HasRequirementLevel(string requirementLevel);

        #endregion
    }
}
