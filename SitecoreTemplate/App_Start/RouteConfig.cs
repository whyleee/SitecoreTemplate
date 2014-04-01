using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.Mvc;
using System.Web.Routing;

namespace SitecoreTemplate.App_Start
{
    public class RouteConfig
    {
        public static void RegisterRoutes(RouteCollection routes)
        {
            // NOTE
            // ====
            // 
            // Default ASP.NET MVC routes are commented, because it can conflict with Sitecore URLs.
            //
            // Do not uncomment them, or you could face unexpected behavior in Sitecore.
            // To register a custom controller, use "%ControllerName%/{action}/{id}" pattern.

            //routes.IgnoreRoute("{resource}.axd/{*pathInfo}");

            //routes.MapRoute(
            //    name: "Default",
            //    url: "{controller}/{action}/{id}",
            //    defaults: new { controller = "Home", action = "Index", id = UrlParameter.Optional }
            //);

            // css/js bundles
            routes.MapRoute(
                name: "css/js bundles",
                url: "bundles/{*pathInfo}"
            );
        }
    }
}