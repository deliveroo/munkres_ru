extern crate munkres;
extern crate libc;

use munkres::WeightMatrix;
use munkres::solve_assignment;

#[repr(C)]
pub struct Array {
    len: libc::size_t,
    data: *const libc::c_int,
}

impl Array {
    fn from_vec(mut vec: Vec<i32>) -> Array {
        vec.shrink_to_fit();
        let array = Array { data: vec.as_ptr() as *const libc::c_int, len: vec.len() as libc::size_t };
        std::mem::forget(vec);
        array
    }
}

impl Drop for Array {
    fn drop(&mut self) {
        unsafe { Vec::from_raw_parts(self.data as *mut i32, self.len, self.len) as Vec<i32> };
    }
}


#[no_mangle]
pub extern fn solve_munkres(n: libc::size_t, array: *mut libc::c_double) -> *mut Array {
    let res = ::std::panic::catch_unwind(|| {
        let size = n as usize;
        let len = size*size;
        let vec = unsafe { Vec::from_raw_parts(array, len, len) };
        for &v in &vec {
            assert!(!v.is_nan());
        }
        let mut weights: WeightMatrix<libc::c_double> = WeightMatrix::from_row_vec(size, vec);
        let matching = solve_assignment(&mut weights);
        let mut res = Vec::new();
        for &(row, col) in &matching[..] {
            res.push(row as libc::c_int);
            res.push(col as libc::c_int);
        }
        Box::new(Array::from_vec(res))
    });
    match res {
        Ok(array) => {
            Box::into_raw(array)
        },
        Err(_) => std::ptr::null_mut(),
    }
}

#[no_mangle]
pub extern fn free_munkres(array: *mut Array) {
    let _res = ::std::panic::catch_unwind(|| {
        unsafe { Box::from_raw(array) };
    });
}
