#include <gtk/gtk.h>

typedef struct {
    GtkWidget       *about_dialog_box;
    GtkWidget       *settings_box;
} app_widgets;

int main(int argc, char *argv[]) {
    GtkBuilder      *root;
    GtkBuilder      *about;
    GtkBuilder      *settings;
    GtkWidget       *window;
    app_widgets     *widgets = g_slice_new(app_widgets);

    gtk_init(&argc, &argv);

    root = gtk_builder_new_from_file("glade/root.glade");
    about = gtk_builder_new_from_file("glade/about.glade");
    settings = gtk_builder_new_from_file("glade/settings.glade");
    window = GTK_WIDGET(gtk_builder_get_object(root, "root"));

    widgets->about_dialog_box = GTK_WIDGET(gtk_builder_get_object(about, "about"));
    widgets->settings_box = GTK_WIDGET(gtk_builder_get_object(settings, "settings"));

    gtk_builder_connect_signals(root, widgets);

    g_object_unref(root);

    gtk_widget_show(window);
    gtk_main();
    g_slice_free(app_widgets, widgets);

    return 0;
}

// Main buttons
void on_Check_kernel_version_clicked() {
    system("sh -c 'echo Operation system: $(lsb_release -ds); echo Kernel version in use: $(uname -r)'");
}

//////// Menu bar buttons //////// 
// File > Quit
void on_about_dialog_quit_activate(GtkMenuItem *menuitem, app_widgets *widgets) {
    gtk_main_quit();
}

// Help > About button
void on_About_activate(GtkMenuItem *menuitem, app_widgets *widgets) {
    gtk_widget_show(widgets->about_dialog_box);
}

// Settings button
void on_Settings_btn_select(GtkWidget *menuitem, app_widgets *widgets) {
    gtk_widget_show(widgets->settings_box);
}

// When window is closed
void on_window_main_destroy() {
    gtk_main_quit();
}
