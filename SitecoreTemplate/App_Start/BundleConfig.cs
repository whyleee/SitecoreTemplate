using System.Web.Optimization;

namespace SitecoreTemplate.App_Start
{
    public class BundleConfig
    {
        public static void RegisterBundles(BundleCollection bundles)
        {
            bundles.UseCdn = true;

            // jquery
            var jquery = new ScriptBundle("~/bundles/jquery",
                cdnPath: "//ajax.googleapis.com/ajax/libs/jquery/2.1.0/jquery.min.js").Include(
                "~/Scripts/jquery-{version}.js"
            );
            jquery.CdnFallbackExpression = "window.jQuery";
            bundles.Add(jquery);

            // js
            bundles.Add(new ScriptBundle("~/bundles/js").Include(
                // Your scripts here...
            ));

            // css
            bundles.Add(new StyleBundle("~/bundles/css").Include(
                // Your css here...
            ));
        }
    }
}