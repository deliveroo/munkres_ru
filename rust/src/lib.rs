extern crate munkres;
extern crate libc;

use munkres::WeightMatrix;
use munkres::solve_assignment;

#[repr(C)]
pub struct Array {
    len: libc::size_t,
    data: *const i32,
}

impl Array {
    fn from_vec<T>(mut vec: Vec<T>) -> Array {
        vec.shrink_to_fit();
        let array = Array { data: vec.as_ptr() as *const i32, len: vec.len() as libc::size_t };
        std::mem::forget(vec);
        array
    }
}


#[no_mangle]
pub extern fn solve_munkres(n: i64, array: *mut f64) -> Array {
    let size = n as usize;
    let len = size*size;
    let vec = unsafe { Vec::from_raw_parts(array, len, len) };
    let mut weights: WeightMatrix<f64> = WeightMatrix::from_row_vec(size, vec);
    let matching = solve_assignment(&mut weights);
    let mut vec = Vec::new();
    for &(row, col) in &matching[..] {
        vec.push(row as i32);
        vec.push(col as i32);
    }
    Array::from_vec(vec)
}
