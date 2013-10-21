using System.Web.Optimization;

namespace SitecoreTemplate.App_Start
{
    public class BundleConfig
    {
        public static void RegisterBundles(BundleCollection bundles)
        {
            bundles.UseCdn = true;

            // jquery
            bundles.Add(new ScriptBundle("~/bundles/jquery",
                cdnPath: "//ajax.googleapis.com/ajax/libs/jquery/2.0.3/jquery.min.js").Include(
                "~/js/jquery/jquery-{version}.js"
            ));

            // js
            bundles.Add(new ScriptBundle("~/bundles/js").Include(
                "~/js/jquery/jquery.unobtrusive*",
                "~/js/jquery/jquery.validate*"
                // Your scripts here...
            ));

            // css
            bundles.Add(new StyleBundle("~/bundles/css").Include(
                // Your css here...
            ));
        }
    }
}