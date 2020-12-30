package gui;

import javafx.collections.FXCollections;
import javafx.fxml.FXML;
import javafx.fxml.Initializable;
import javafx.scene.Parent;
import javafx.scene.Scene;
import javafx.scene.control.Button;
import javafx.scene.control.TableColumn;
import javafx.scene.control.TableView;
import javafx.scene.control.cell.PropertyValueFactory;
import javafx.stage.Stage;
import model.ExistingImage;
import model.Image;
import model.ImageManager;

import java.io.IOException;
import java.net.URL;
import java.util.ArrayList;
import java.util.ResourceBundle;

/**
 * ListAllController is a controller to be responsible for all the operations when buttons are clicked in the
 * ListAllScene. Turn to AddTagScene when chooseButton is clicked. And turn to MainScene when goBack
 * Button is clicked.
 * @see Parent
 * @see Scene
 * @see Stage
 * @see Button
 * @see Image
 */
public class ListAllController implements Initializable, ChangeScene{

    private static Image chosenImage;

    @FXML Button chooseButton;

    @FXML Button goBackButton;

    @FXML
    private TableView<ExistingImage> table;

    @FXML
    private TableColumn<ExistingImage, String> nameColumn;

    @FXML
    private TableColumn<ExistingImage, String> pathColumn;

    /**
     * This method is called firstly once the ListAllscene is displayed. Draw the table based on all the images under
     * the directory that the user chooses;
     * @param location default
     * @param resources default
     */

    @Override
    public void initialize(URL location, ResourceBundle resources) {
        //draw the table when the scene is initialized
        nameColumn.setCellValueFactory(new PropertyValueFactory<>("name"));
        pathColumn.setCellValueFactory(new PropertyValueFactory<>("path"));
        String path = MainSceneController.getPath();
        ArrayList<ExistingImage> allImages;
        try {
            allImages = Main.system.getDirectoryManager().findAllImages(path);
            table.setItems(FXCollections.observableArrayList(allImages));
        } catch (IOException e) {
            e.printStackTrace();
        }

    }
    /**
     * This method is called when chooseButton is clicked. Make the Image chosen by the user associated with the
     * contronller. Turn to AddTag scene then.
     * @throws IOException
     */
    public void chooseButtonClicked() throws IOException {
        ImageManager imageManager = Main.system.getImageManager();
        ExistingImage selected = table.getSelectionModel().getSelectedItem();
        Image targetImage = imageManager.foundImage(selected.getPath());
        if (targetImage == null) {
            chosenImage = new Image(selected.getImageName(), selected.getImageType(), selected.getPath());
            imageManager.addImage(chosenImage);
        } else {
            chosenImage = targetImage;
        }
        changeScene(chooseButton, "../scenes/AddTagScene.fxml");

    }
    /**
     * This method is called when when goBack Button is clicked. Turn to MainScene then.
     */
    public void goBackButtonClicked() throws IOException {
        changeScene(goBackButton, "../scenes/MainScene.fxml");
    }

    /**
     * This method returns the Image associated with the Controller, which is chosen by the user.
     * @return  Image
     */
    public static Image getChosenImage() {
        return chosenImage;
    }
}