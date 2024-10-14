use std::sync::Arc;
use tokio::sync::Mutex;

use lazy_static::lazy_static;

lazy_static! {
    pub static ref SHARED_MUTEX: Arc<Mutex<i32>> = Arc::new(Mutex::new(0));
}
