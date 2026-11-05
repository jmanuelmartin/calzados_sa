import java.sql.*;
import java.util.Scanner;

public class CalzadosSA {

  public static void main(String[] args) {

    try {
      // Configuración de variables para la conexión a la base de datos MySQL
      String driver = "com.mysql.cj.jdbc.Driver";
      String url = "jdbc:mysql://localhost:3306/calzados_sa?serverTimezone=UTC";
      String username = "root";
      String password = "clave";

      // Cargar el driver de la base de datos y establecer la conexión
      Class.forName(driver);
      Connection connection = DriverManager.getConnection(url, username, password);

      Scanner input = new Scanner(System.in);

      while (true) {
        System.out.println("Elija la opción que quiere realizar:");
        System.out.println("(1) Insertar datos del proveedor");
        System.out.println("(2) Eliminar un proveedor dado su CUIT");
        System.out.println("(3) Listar todos los proveedores");
        System.out.println("(4) Salir\n");

        System.out.print("Opción elegida: ");
        int opcion = Integer.parseInt(input.nextLine().trim());

        if (opcion < 1 || opcion > 4) {
          System.out.println("\nLa opción elegida no se encuentra disponible. Elija otra funcionalidad.");
          Thread.sleep(1000);
          limpiarPantalla();
          continue;
        }

        System.out.println("\nSu opción elegida fue (" + opcion + ").");

        String query = "";
        switch (opcion) {
          // Opción 1: Solicitar e insertar en la BBDD los datos de un proveedor
          case 1:
            System.out.print("1. Ingrese su CUIT: ");
            String cuit = input.nextLine();

            System.out.print("\n2. Ingrese su razón social: ");
            String razon_social = input.nextLine();

            System.out.print("\n3. Ingrese su dirección: ");
            String direccion = input.nextLine();

            System.out.print("\n4. Ingrese su teléfono fijo: ");
            String telefono_fijo = input.nextLine();

            // Usamos el comodín "?" para evitar SQL Injection
            query = "INSERT INTO Proveedor (cuit, razon_social, direccion, telefono_fijo)" +
                "VALUES (?, ?, ?, ?)";

            // Preparamos la query con los valores del proveedor
            try (PreparedStatement statement = connection.prepareStatement(query)) {
              statement.setString(1, cuit);
              statement.setString(2, razon_social);
              statement.setString(3, direccion);
              statement.setString(4, telefono_fijo);
              // executeUpdate(): envía la query y devuelve la cantidad de filas afectadas
              int filas = statement.executeUpdate();

              if (filas > 0) {
                System.out.println("\nSe ha insertado correctamente el proveedor.\n");
              } else {
                System.out.println("\nNo se ha podido insertar el proveedor.\n");
              }

              Thread.sleep(2000);
              limpiarPantalla();
            } catch (SQLException e) {
              throw new SQLException("Error al insertar el proveedor: " + e.getMessage());
            }

            break;
          // Opción 2: Eliminar un proveedor específico a través de su clave primaria (cuit)
          case 2:
            System.out.print("1. Ingrese el CUIT del proveedor a eliminar: ");
            String cuitD = input.nextLine();

            query = "DELETE FROM Proveedor WHERE cuit = ?";

            try (PreparedStatement statement = connection.prepareStatement(query)) {
              statement.setString(1, cuitD);
              int filas = statement.executeUpdate();

              if (filas > 0) {
                System.out.println("\nSe ha eliminado correctamente el proveedor.\n");
              } else {
                System.out.println("\nNo existe ningún proveedor con ese CUIT.\n");
              }

              Thread.sleep(2000);
              limpiarPantalla();
            } catch (SQLException e) {
              throw new SQLException("Error al eliminar el proveedor: " + e.getMessage());
            }

            break;
          // Opción 3: Listar todos los registros de la tabla Proveedor
          case 3:
            query = "SELECT * FROM Proveedor;";
            PreparedStatement statement = connection.prepareStatement(query);
            ResultSet resultSet = statement.executeQuery();
            Thread.sleep(1000);
            limpiarPantalla();
            System.out.println("\n//-------- Consulta de Proveedores --------//");
            // Iteramos sobre los resultados devueltos por la base de datos
            while (resultSet.next()) {
              System.out.println();
              System.out.print("+ CUIT: " + resultSet.getString("cuit"));
              System.out.print("; Razón Social: " + resultSet.getString("razon_social"));
              System.out.print("; Direccion: " + resultSet.getString("direccion"));
              System.out.print("; Teléfono fijo: " + resultSet.getString("telefono_fijo"));
              System.out.print("\n   ");
              System.out.print("\n   ");
            }
            System.out.println("\n//-----------------------------------------//");

            boolean flag = false;
            while (!flag) {
              System.out.println("\nInserte (4) para volver al menú.");

              System.out.print("Opción elegida: ");
              int opcionListar = Integer.parseInt(input.nextLine().trim());
              if (opcionListar == 4) {
                flag = true;
              } else {
                System.out.println("Opción no válida.");
              }
            }

            Thread.sleep(2000);
            limpiarPantalla();
            break;
          case 4:
            input.close();
            return;
          default:
            break;
        }
      }

    // Bloque catch para capturar y mostrar posibles errores de SQL
    } catch (ClassNotFoundException cnfe) {
      System.err.println("Error loading driver: " + cnfe);
      cnfe.printStackTrace();
    } catch (SQLException sqle) {
      sqle.printStackTrace();
      System.err.println("Error connecting: " + sqle);
    } catch (Exception sqle) {
      sqle.printStackTrace();
      System.err.println("Error connecting: " + sqle);
    }
  }

  // Método auxiliar para limpiar la terminal
  public static void limpiarPantalla() {
    try {
      if (System.getProperty("os.name").toLowerCase().contains("win")) {
        new ProcessBuilder("cmd", "/c", "cls").inheritIO().start().waitFor();
      } else {
        new ProcessBuilder("clear").inheritIO().start().waitFor();
      }
    } catch (Exception e) {
      // Si falla, no se ejecuta nada
    }
  }

}