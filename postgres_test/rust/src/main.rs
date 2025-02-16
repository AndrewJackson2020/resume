use postgres::{Client, NoTls};

fn main() -> Result<(), postgres::Error>{
    let mut client = Client::connect("postgresql://andrew@example.com/postgres?target_session_attrs=read-only", NoTls)?;


    for row in client.query("SELECT 1", &[])? {
        let id: i32 = row.get(0);

        println!("found person: {} ", id);
    }
    Ok(())
}
