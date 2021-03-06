extern crate munkres;
extern crate libc;

use munkres::WeightMatrix;
use munkres::solve_assignment;

use libc::{c_int, size_t};
use std::ptr;

#[repr(C)]
pub struct Array {
    len: libc::size_t,
    data: *const c_int,
}

impl Array {
    fn from_vec(mut vec: Vec<c_int>) -> Array {
        vec.shrink_to_fit();
        let array = Array {
            data: vec.as_ptr() as *const c_int,
            len: vec.len() as size_t,
        };
        std::mem::forget(vec);
        array
    }
}

impl Drop for Array {
    fn drop(&mut self) {
        unsafe { Vec::from_raw_parts(self.data as *mut c_int, self.len, self.len) as Vec<c_int> };
    }
}


#[no_mangle]
pub extern "C" fn solve_munkres(n: libc::size_t, array: *const libc::c_double) -> *mut Array {
    let res = ::std::panic::catch_unwind(|| {
        let size = n as usize;
        let len = size * size;
        let slice = unsafe { std::slice::from_raw_parts(array, len) };
        for v in slice {
            assert!(!v.is_nan());
        }
        let mut weights: WeightMatrix<libc::c_double> = WeightMatrix::from_row_vec(size, slice.to_vec());
        let matching = solve_assignment(&mut weights);
        let mut res = Vec::new();
        for (row, col) in matching {
            res.push(row as libc::c_int);
            res.push(col as libc::c_int);
        }
        Box::new(Array::from_vec(res))
    });
    match res {
        Ok(array) => Box::into_raw(array),
        Err(_) => ptr::null_mut(),
    }
}

#[no_mangle]
pub extern "C" fn free_munkres(array: *mut Array) {
    let _res = ::std::panic::catch_unwind(|| { unsafe { Box::from_raw(array) }; });
}

// #[cfg(test)]
// mod tests {
//     use super::*;
//     use test::Bencher;

//     #[bench]
//     fn solve_munkres1_bench(b: &mut Bencher) {
//         let problem = &[
//             1.0, 1.0, 1.0, 1.0, 1.0,
//             1.0, 1.0, 1.0, 1.0, 1.0,
//             1.0, 1.0, 1.0, 1.0, 1.0,
//             0.0, 0.0, 0.0, 0.0, 0.0,
//             0.0, 0.0, 0.0, 0.0, 0.0
//         ];
//         b.iter(|| solve_munkres(5, problem.as_ptr()));
//     }
// }
